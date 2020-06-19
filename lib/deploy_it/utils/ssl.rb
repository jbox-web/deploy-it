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

require 'openssl'

module DeployIt
  module Utils
    module Ssl
      extend self

      def valid_ssl_cert?(crt)
        ssl_cert(crt) rescue false
      rescue OpenSSL::X509::CertificateError => e
        false
      end


      def valid_ssl_key?(key)
        ssl_key(key)
      rescue OpenSSL::PKey::RSAError => e
        false
      end


      def key_match_cert?(key, crt)
        crt = ssl_cert(crt)
        key = ssl_key(key)
        crt.check_private_key(key)
      rescue OpenSSL::X509::CertificateError, OpenSSL::PKey::RSAError => e
        false
      end


      private


        def ssl_cert(crt)
          OpenSSL::X509::Certificate.new(crt)
        end


        def ssl_key(key)
          OpenSSL::PKey::RSA.new(key)
        end

    end
  end
end
