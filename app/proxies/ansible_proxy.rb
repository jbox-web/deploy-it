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


  def run_playbook(playbook, extra_vars)
    vars_file = vars_to_file(extra_vars)

    params = [
      'ANSIBLE_HOST_KEY_CHECKING=False',
      'ansible-playbook',
      '--inventory-file', INVENTORY_FILE,
      '--private-key', private_key_to_file,
      '--extra-vars', "CONTAINER_VARS=#{vars_file}",
      playbook
    ]

    log_regex = /TASK:\s\[([\w\s\:]+)\]\s\*+/

    begin
      out = DeployIt::Utils.capture('/usr/bin/env', params)
    rescue => e
      # Re raise errors
      DeployIt.file_logger.error e.message
      raise e
    else
      logs = []
      out.split("\n").each do |line|
        next if !line.match(log_regex)
        text = line.match(log_regex)[1]
        logs << text
      end
      return logs
    ensure
      FileUtils.rm_f(vars_file)
      destroy_temp_keys
    end
  end


  private


    def vars_to_file(vars)
      DeployIt::Utils.write_yaml_file(format_var(vars))
    end


    def format_var(vars)
      new_hash = {}
      # Inject additional variables and convert Hash keys from symbols to upercase strings
      vars.merge(host: host_name, user: user, port: port).each { |k, v| new_hash[k.to_s.upcase] = v }
      new_hash
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
