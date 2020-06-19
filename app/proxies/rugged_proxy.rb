# frozen_string_literal: true
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

  attr_reader :local_branch
  attr_reader :remote_branch
  attr_reader :errors


  def initialize(path, branch, credentials = {})
    @path        = path
    @branch      = branch
    @credentials = credentials

    @local_branch  = "refs/heads/#{branch}"
    @remote_branch = "refs/remotes/origin/#{branch}"
    @errors        = []
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
    local_repo.empty? rescue true
  end


  def last_commit_info(type)
    return get_message(last_commit_id) if type == :message
    get_author(last_commit_id)[type] rescue ''
  end


  def last_commit_id
    local_repo.head.target_id rescue ''
  end


  def get_author(ref)
    get_commit(ref).author rescue ''
  end


  def get_message(ref)
    get_commit(ref).message rescue ''
  end


  def get_commit(ref = '')
    return '' if ref == ''
    local_repo.lookup(ref)
  end


  def commit_distance
    from = find_branch(local_branch).target_id rescue ''
    to   = find_branch(remote_branch).target_id rescue ''
    data = {}
    data[:from] = { commit_id: from, author: get_author(from), message: get_message(from) }
    data[:to]   = { commit_id: to, author: get_author(to), message: get_message(to) }
    data
  end


  def last_commit_on_remote
    find_branch(remote_branch).target
  end


  def has_pending_commits?
    return false if local_repo.nil?
    # Fetch refspecs from remote and analyze the distance from the last commit
    fetch && local_repo.merge_analysis(last_commit_on_remote).include?(:fastforward)
  end


  def remote_exists?
    return true unless find_branch(remote_branch).nil?
    @errors << "La branche distante n'existe pas"
    false
  end


  def find_branch(branch)
    local_repo.references[branch]
  end


  def clone_from(url)
    clone_at(url, path, clone_options)
  end


  def clone_at(url, path, opts = {})
    clone(url, path, opts)
  end


  def fetch
    begin
      local_repo.fetch('origin', credentials_options)
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
    return false if !syncable?
    begin
      DeployIt::Utils::Exec.capture('/usr/bin/env', pull_params)
      pulled = true
    rescue DeployIt::Error::IOError => e
      @errors << treat_exception(e)
      pulled = false
    ensure
      destroy_temp_keys
    end
    pulled
  end


  def archive(revision = 'master')
    return nil if !pull
    archive_file = DeployIt::Utils::Files.get_temp_file + '.tar'
    begin
      DeployIt::Utils::Exec.capture('/usr/bin/env', archive_params(revision, archive_file))
    rescue DeployIt::Error::IOError => e
      @errors << treat_exception(e)
      nil
    else
      if File.exists?(archive_file) && !File.zero?(archive_file)
        archive_file
      else
        @errors << "archive file wasn't correctly generated"
        nil
      end
    end
  end


  private


    def archive_params(revision, output_file)
      ['-i', "GIT_DIR=#{path}/.git", 'git', 'archive', revision, '-o', output_file]
    end


    def clone_options
      { checkout_branch: branch, ignore_cert_errors: true }.merge(credentials_options)
    end


    def pull_params
      [
        '-i', "PRIVATE_KEY=#{private_key_to_file(credentials[:private_key])}", "GIT_SSH=#{ssh_wrapper}",
        'git', '-C', path, 'pull'
      ]
    end


    def ssh_wrapper
      Rails.root.join('wrappers', 'ssh-git.sh').to_s
    end


    def local_repo
      @local_repo ||=
        begin
          ::Rugged::Repository.new(path)
        rescue => e
          @errors << treat_exception(e)
          nil
        end
    end


    def clone(url, path, opts = {})
      begin
        ::Rugged::Repository.clone_at(url, path, opts)
        cloned = true
      rescue => e
        @errors << treat_exception(e)
        cloned = false
      ensure
        destroy_temp_keys
      end
      cloned
    end


    def credentials_options
      return {} if credentials.empty?
      { credentials: build_credentials(credentials) }
    end


    def build_credentials(credentials)
      if credentials[:type] == :ssh_key
        ::Rugged::Credentials::SshKey.new(
          username:   credentials[:username],
          publickey:  public_key_to_file(credentials[:public_key]),
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
      when DeployIt::Error::IOError
        message = "Erreur lors de l'exécution de la commande"
      else
        message = exception.message
      end
      message
    end

end
