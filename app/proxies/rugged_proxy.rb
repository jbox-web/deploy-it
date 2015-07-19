# DeployIt - Docker containers management software
# Copyright (C) 2015 Nicolas Rodriguez (nrodriguez@jbox-web.com), JBox Web (http://www.jbox-web.com)
#
# This code is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License, version 3,
# as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License, version 3,
# along with this program.  If not, see <http://www.gnu.org/licenses/>

require 'rugged'

class RuggedProxy

  attr_reader :path
  attr_reader :branch
  attr_reader :credentials
  attr_reader :errors


  def initialize(path, branch, credentials = {})
    @path        = path
    @branch      = branch
    @credentials = credentials
    @errors      = []
  end


  def local_branch
    "refs/heads/#{branch}"
  end


  def remote_branch
    "refs/remotes/origin/#{branch}"
  end


  def ssh_wrapper
    Rails.root.join('wrappers', 'ssh-git.sh').to_s
  end


  def synced?
    !has_pending_commits?
  end


  def syncable?
    !local_repo.nil? && remote_exists? && fetchable?
  end


  def fetchable?
    fetch
  end


  def empty?
    local_repo.empty?
  rescue => e
    true
  end


  def get_commit(ref)
    return '' if ref == ''
    local_repo.lookup(ref)
  end


  def get_author(commit)
    get_commit(commit).author rescue ''
  end


  def get_message(commit)
    get_commit(commit).message rescue ''
  end


  def last_commit
    local_repo.head.target_id
  rescue
    ''
  end


  def last_commit_author_name
    author = get_author(last_commit)
    author[:name]
  rescue
    ''
  end


  def last_commit_author_mail
    author = get_author(last_commit)
    author[:email]
  rescue
    ''
  end


  def last_commit_date
    author = get_author(last_commit)
    author[:time]
  rescue
    ''
  end


  def last_commit_message
    get_message(last_commit)
  end


  def commit_distance
    from = local_repo.references[local_branch].target_id rescue ''
    to   = local_repo.references[remote_branch].target_id rescue ''
    {
      from: {
        commit_id: from,
        author: get_author(from),
        message: get_message(from)
      },
      to: {
        commit_id: to,
        author: get_author(to),
        message: get_message(to)
      }
    }
  end


  def fetch
    options = {}
    options = options.merge(credentials_options)
    begin
      local_repo.fetch('origin', options)
      fetched = true
    rescue => e
      @errors << treat_exception(e)
      fetched = false
    ensure
      destroy_temp_keys
    end

    fetched
  end


  def pull
    if syncable?
      params = [
        "-i",
        "PRIVATE_KEY=#{private_key_to_file(credentials[:private_key])}",
        "GIT_SSH=#{ssh_wrapper}",
        "git",
        "-C",
        "#{path}",
        "pull"
      ]

      begin
        DeployIt::Utils.capture('/usr/bin/env', params)
        pulled = true
      rescue => e
        @errors << treat_exception(e)
        pulled = false
      ensure
        destroy_temp_keys
      end

      pulled
    else
      false
    end
  end


  def clone_at(url)
    clone_options = { checkout_branch: branch, ignore_cert_errors: true }
    clone_options = clone_options.merge(credentials_options)

    begin
      ::Rugged::Repository.clone_at(url, path, clone_options)
      cloned = true
    rescue => e
      @errors << treat_exception(e)
      cloned = false
    ensure
      destroy_temp_keys
    end

    cloned
  end


  def init_at
    ::Rugged::Repository.init_at(path, :bare)
  end


  def archive(revision = 'master')
    if pull
      temp_dir = Dir.mktmpdir
      begin
        repo = ::Rugged::Repository.clone_at(path, temp_dir)
        repo.checkout revision, update_submodules: true
      rescue => e
        @errors << treat_exception(e)
        return nil
      else
        File.chmod(0755, temp_dir)
        FileUtils.rm_rf(File.join(temp_dir, '.git'))
        %x[ cd #{temp_dir} && tar -cf "#{temp_dir}.tar" . > /dev/null 2>&1 ]
        return "#{temp_dir}.tar"
      ensure
        FileUtils.rm_rf temp_dir
      end
    end
  end


  private


    def local_repo
      @local_repo ||=
        begin
          ::Rugged::Repository.new(path)
        rescue => e
          @errors << treat_exception(e)
          nil
        end
    end


    def credentials_options
      return {} if credentials.empty?
      { credentials: build_credentials(credentials) }
    end


    def build_credentials(credentials)
      if credentials[:type] == :ssh_key
        ::Rugged::Credentials::SshKey.new(
          username: credentials[:username],
          publickey: public_key_to_file(credentials[:public_key]),
          privatekey: private_key_to_file(credentials[:private_key])
        )
      elsif credentials[:type] == :basic_auth
        ::Rugged::Credentials::UserPassword.new(
          username: credentials[:login],
          password: credentials[:password]
        )
      end
    end


    def public_key_to_file(key)
      @public_key_file = Tempfile.new('ssh_public_key', Rails.root.join('tmp'))
      @public_key_file.write key
      @public_key_file.close
      @public_key_file.path
    end


    def private_key_to_file(key)
      @private_key_file = Tempfile.new('ssh_private_key', Rails.root.join('tmp'))
      @private_key_file.write key
      @private_key_file.close
      @private_key_file.path
    end


    def remote_exists?
      if find_remote_branch.nil?
        @errors << "La branche distante n'existe pas"
        false
      else
        true
      end
    end


    def find_remote_branch
      local_repo.references[remote_branch]
    end


    def find_last_commit_on_remote
      find_remote_branch.target
    end


    def has_pending_commits?
      return false if local_repo.nil?

      # Fetch refspecs from remote
      fetch

      # Get last commit_id on remote
      remote_commit = find_last_commit_on_remote

      # Analyze the distance from the last commit
      if local_repo.merge_analysis(remote_commit).include?(:fastforward)
        true
      else
        false
      end
    end


    def destroy_temp_keys
      @public_key_file.unlink unless @public_key_file.nil?
      @private_key_file.unlink unless @private_key_file.nil?
    end


    def treat_exception(exception)
      case exception
      when ::Rugged::OSError
        message = "Le dépôt n'existe pas"
      when ::Rugged::SshError
        message = "Vous devez créer une clé d'accès pour ce dépôt"
      else
        message = exception.message
      end
      message
    end

end
