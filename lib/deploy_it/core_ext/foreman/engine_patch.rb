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

require 'dotenv'
require 'foreman'
require 'foreman/engine'

module DeployIt
  module CoreExt
    module Foreman
      module EnginePatch

        def self.included(base)
          base.send(:prepend, InstanceMethods)
        end


        module InstanceMethods

          def load_env(filename)
            @env.update Dotenv::Environment.new(filename)
          end


          def terminate_gracefully
            return if @terminating
            restore_default_signal_handlers
            @terminating = true
            command = ::Foreman.windows? ? 'SIGKILL' : 'SIGTERM'
            Timeout.timeout(options[:timeout]) do
              watch_for_termination do
                system  "sending #{command} to all processes"
                kill_children command
              end while @running.length > 0
            end
          rescue Timeout::Error
            system  "sending SIGKILL to all processes"
            kill_children "SIGKILL"
          end

        end

      end
    end
  end
end

unless Foreman::Engine.included_modules.include?(DeployIt::CoreExt::Foreman::EnginePatch)
  Foreman::Engine.send(:include, DeployIt::CoreExt::Foreman::EnginePatch)
end
