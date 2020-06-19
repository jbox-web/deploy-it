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

require 'securerandom'

module DeployIt
  module Utils
    module Crypto
      extend self

      def generate_secret(length)
        length = length.to_i
        secret = SecureRandom.base64(length * 2)
        secret = secret.gsub(/[\=\_\-\+\/]/, '')
        secret = secret.split(//).sample(length).join('')
        secret
      end

    end
  end
end
