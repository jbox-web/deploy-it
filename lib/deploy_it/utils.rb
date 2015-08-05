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

require 'json'
require 'net/http'
require 'net/https'
require 'open3'
require 'securerandom'
require 'uri'

module DeployIt
  module Utils

    class << self

      def display_errors_on_console(errors)
        DeployIt.console_logger.info ""
        errors.each do |error|
          DeployIt.console_logger.error error
        end
        DeployIt.console_logger.info ""
      end


      def parse_repository_from_ssh_command
        ENV['SSH_ORIGINAL_COMMAND'].split(' ')[1].gsub!("'", '').gsub!('.git', '')
      end


      def parse_git_command_from_ssh_command
        ENV['SSH_ORIGINAL_COMMAND'].split(' ')[0]
      end


      def post_data(url, data)
        uri  = URI(url)
        http = Net::HTTP.new(uri.host, uri.port)

        if uri.scheme == 'https'
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end

        request = Net::HTTP::Post.new(uri.request_uri)
        request.set_form_data(data)

        begin
          response = http.start {|openhttp| openhttp.request request}
          if !response.is_a?(Net::HTTPSuccess)
            message = "AuthServer is not reachable !"
            failed = true
          else
            message = JSON::load(response.body)
            failed = false
          end
        rescue => e
          message = "AuthServer is not reachable !"
          failed = true
        end

        return failed, message
      end


      def capture(command, args = [])
        output, err, code = execute(command, args)
        if code != 0
          error_msg = "Non-zero exit code #{code} for `#{command} #{args.join(" ")}`"
          DeployIt.file_logger.error error_msg
          raise DeployIt::Error::IOError
        end
        output
      end


      def execute(command, args = [])
        Open3.capture3(command, *args)
      rescue => e
        error_msg = "Exception occured executing `#{command} #{args.join(" ")}` : #{e.message}"
        DeployIt.file_logger.error error_msg
        raise DeployIt::Error::IOError
      end


      def generate_secret(length)
        length = length.to_i
        secret = SecureRandom.base64(length * 2)
        secret = secret.gsub(/[\=\_\-\+\/]/, '')
        secret = secret.split(//).sample(length).join('')
        secret
      end


      def build_is_valid?(local_ref)
        while data = $stdin.gets
          old_revision, new_revision, pushed_ref = data.chomp.split(" ")
          if pushed_ref == local_ref
            valid = true
          else
            valid = false
          end
        end
        return valid, { old_revision: old_revision, new_revision: new_revision, ref_name: pushed_ref }
      end


      def write_yaml_file(data)
        # Get random file
        file = Tempfile.new('temp')
        filepath = file.path
        file.close!
        # Write file
        write_file(filepath, data.to_yaml)
        return filepath
      end


      def write_file(file, content)
        File.open(file, 'w+') {|f| f.write(content) }
      end

    end

  end
end
