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

require 'fileutils'

class AnsibleProxy

  class << self

    def hash_to_string(hash)
      hash.map{ |key, value| "#{key}=#{value}" }.join(' ')
    end


    def hash_to_array(hash)
      array = []
      hash.each do |server, options|
        array << "#{server} #{hash_to_string(options)}"
      end
      array
    end


    def generate_inventory_file(server_list, force_creation = true)
      content = hash_to_array(server_list).join("\n") + "\n"

      if !File.exists?(INVENTORY_FILE) || (File.exists?(INVENTORY_FILE) && force_creation)
        begin
          File.open(INVENTORY_FILE, 'w+') {|f| f.write(content) }
        rescue => e
          # Re raise errors
          raise e
        end
      end
    end

  end


  INVENTORY_FILE = Rails.root.join('tmp', 'hosts').to_s
  ANSIBLE_EXIT_STATUS = {
    1 => DeployIt::Error::InvalidServerUpdate,
    2 => DeployIt::Error::UnreachableServer,
    3 => DeployIt::Error::ServerUpdateFailed
  }


  attr_reader :host_name
  attr_reader :private_key
  attr_reader :user
  attr_reader :port


  def initialize(host_name, private_key, opts = {})
    @host_name   = host_name
    @private_key = private_key
    @user        = opts.delete(:user){ 'root' }
    @port        = opts.delete(:port){ 22 }
  end


  def run_playbook(playbook, extra_vars, opts = {})
    extra_vars = extend_vars(extra_vars)
    vars_file = DeployIt::Utils::Files.write_yaml_file(extra_vars)
    params = default_params.concat(["CONTAINER_VARS=#{vars_file}", playbook])

    begin
      output, err, status = DeployIt::Utils::Exec.execute('/usr/bin/env', params)
    rescue DeployIt::Error::IOError => e
      raise e
    else
      if opts[:debug]
        DeployIt.file_logger.error params
        DeployIt.file_logger.error extra_vars
        DeployIt.file_logger.error output
        DeployIt.file_logger.error err
      end
      exception = ANSIBLE_EXIT_STATUS[status.exitstatus] || DeployIt::Error::ServerUpdateFailed
      raise exception unless status.exitstatus == 0
    ensure
      FileUtils.rm_f(vars_file)
      destroy_temp_keys
    end
  end


  private


    def default_params
      [
        'ANSIBLE_SSH_PIPELINING=True',
        'ANSIBLE_HOST_KEY_CHECKING=False',
        'ansible-playbook',
        '--inventory-file', INVENTORY_FILE,
        '--private-key', private_key_to_file,
        '--extra-vars'
      ].clone
    end


    def extend_vars(extra_vars)
      extra_vars.merge(host: host_name, user: user, port: port).map_keys!(&:to_s).map_keys!(&:upcase)
    end


    def private_key_to_file
      @private_key_file = Tempfile.new('ssh_private_key', Rails.root.join('tmp'))
      @private_key_file.write private_key
      @private_key_file.close
      @private_key_file.path
    end


    def destroy_temp_keys
      @private_key_file.unlink unless @private_key_file.nil?
    end

end
