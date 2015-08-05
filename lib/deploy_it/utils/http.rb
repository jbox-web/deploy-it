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
require 'uri'

module DeployIt
  module Utils
    module Http
      extend self

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

    end
  end
end
