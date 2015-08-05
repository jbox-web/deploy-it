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

module DockerServices
  class AppScaler

    attr_reader :application
    attr_reader :logger
    attr_reader :release


    def initialize(application, logger)
      @application = application
      @logger      = logger
      @release     = application.releases.last
    end


    def run!
      spin_front_container
      if application.use_cron?
        spin_cron_container
      else
        remove_cron_container
      end
    end


    private


      def spin_front_container
        # Mark old containers
        application.mark_containers!(type: :front)

        started = 0

        application.instance_number.times.each do |instance|
          # Create new container in Database
          container = application.create_container!(type: :front, release_id: release.id)

          logger.title("Start container instance : #{instance + 1}/#{application.instance_number}")

          hostname = "#{application.fullname_with_dashes}"
          domain_name = "v#{release.version}.web.#{instance + 1}"

          begin
            deployer = DockerServices::AppDeployer.new(:web, application, container, hostname, domain_name, logger)
            deployer.run!
          rescue => e
            DeployIt.file_logger.error e.message
            next
          else
            started += 1
          end
        end

        if started == 0
          application.unmark_containers!(type: :front)
          raise "Errors while starting web instances"
        else
          logger.banner('Notifying router :')
          application.switch_containers!(type: :front, version: release.version)
          logger.padded('Done !')
        end
      end


      def spin_cron_container
        # Mark old containers
        application.mark_containers!(type: :cron)

        # Create new container in Database
        container = application.create_container!(type: :cron, release_id: release.id)

        hostname = "#{application.fullname_with_dashes}"
        domain_name = "v#{release.version}.cron.1"

        started = 0

        begin
          deployer = DockerServices::AppDeployer.new(:cron, application, container, hostname, domain_name, logger)
          deployer.run!
        rescue => e
          DeployIt.file_logger.error e.message
        else
          started += 1
        end

        if started == 0
          application.unmark_containers!(type: :cron)
          raise "Errors while starting Cron instances"
        else
          application.switch_containers!(type: :cron, version: release.version)
        end
      end


      def remove_cron_container
        application.mark_containers!(type: :cron)
        application.delete_containers!(type: :cron)
      end

  end
end
