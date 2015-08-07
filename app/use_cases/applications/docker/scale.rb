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

module Applications
  module Docker
    class Scale < ActiveUseCase::Base

      attr_reader :logger


      def execute(logger)
        @logger = logger
        spin_container(:web, application.instance_number)
        application.use_cron? ? spin_container(:cron) : remove_container(:cron)
      end


      def spin_container(type, instance_number = 1)
        # Mark old containers
        application.mark_containers!(type: type)

        started = 0
        instance_number.times.each do |instance|
          id = instance + 1
          logger.title(tt('notice.starting_container', type: type, id: id, instance_number: instance_number))
          started += 1 if create_container(type, id)
        end

        if started == 0
          application.unmark_containers!(type: type)
          error_message(tt('errors.no_instance_started', type: type))
        else
          application.switch_containers!(type: type, version: release.version)
          if type == :web
            logger.banner(tt('notice.notifying_router'))
            application.update_lb_route!
            logger.padded('Done !')
          end
        end
      end


      def create_container(type, id = 1)
        # Create new container in Database
        container = application.create_container!(type: type, release_id: release.id)
        hostname = "#{application.fullname_with_dashes}"
        domain_name = "v#{release.version}.#{type}.#{id}"
        use_case = container.deploy!(logger, hostname, domain_name)
        use_case.success?
      end


      def remove_container(type)
        application.mark_containers!(type: type)
        application.delete_containers!(type: type)
      end


      def release
        application.releases.last
      end

    end
  end
end
