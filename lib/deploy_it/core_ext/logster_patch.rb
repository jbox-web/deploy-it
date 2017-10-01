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

require 'logster/logger'
require 'logster/message'

module DeployIt
  module CoreExt
    module LogsterPatch
      module LogsterMessagePatch

        # Fix error : "Failed to report error: no implicit conversion of ActionDispatch::Request into Hash"
        def populate_from_env(env)
          env ||= {}
          env = { 'error' => env } unless env.is_a?(Hash)
          @env = Logster::Message.populate_from_env(self.class.default_env.merge env)
        end

      end

      module LogsterLoggerPatch

        def silence(*)
          yield self
        end

      end
    end
  end
end

unless Logster::Message.included_modules.include?(DeployIt::CoreExt::LogsterPatch::LogsterMessagePatch)
  Logster::Message.send(:prepend, DeployIt::CoreExt::LogsterPatch::LogsterMessagePatch)
end

unless Logster::Logger.included_modules.include?(DeployIt::CoreExt::LogsterPatch::LogsterLoggerPatch)
  Logster::Logger.send(:prepend, DeployIt::CoreExt::LogsterPatch::LogsterLoggerPatch)
end
