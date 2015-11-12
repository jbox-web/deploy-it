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

module DCI
  module Roles
    class ApplicationConfigManager < Base

      include ApplicationCommon


      def update_settings(application, params = {})
        update_application(application, params) do |application|
          application.run_async!('update_files!')
        end
      end


      def update_repository(application, params = {})
        distant_repo = application.distant_repo
        local_repo   = application.local_repo

        if distant_repo.update(params)
          if distant_repo.url_has_changed? || distant_repo.branch_has_changed?
            reset_repository(distant_repo)
            reset_repository(local_repo)
          else
            !distant_repo.exists? ? distant_repo.run_async!('clone!') : distant_repo.run_async!('resync!')
          end

          # Call service objects to perform other actions
          application.run_async!('update_files!')

          context.render_success(locals: { application: application })
        else
          context.render_failed(locals: { application: application })
        end
      end


      def reset_repository(repository)
        if repository.is_a?(ApplicationRepository)
          repository.destroy_dir!
          repository.run_async!('clone!')
        elsif repository.is_a?(ContainerRepository)
          repository.destroy_dir!
          repository.init_bare!
        end
      end


      def update_addons(application, params = {})
        update_application(application, params)
      end


      def update_domain_names(application, params = {})
        update_application(application, params)
      end


      def update_credentials(application, params = {})
        update_application(application, params) do |application|
          disable_credentials(application) if application.credentials.empty?
          application.run_async!('create_lb_route!')
        end
      end


      def update_env_vars(application, params = {})
        update_application(application, params) do |application|
          application.run_async!('update_files!')
        end
      end


      def update_mount_points(application, params = {})
        update_application(application, params) do |application|
          application.run_async!('update_files!')
        end
      end


      def ssl_certificate(application, params = {})
        return context.render_failed(locals: { application: application }, message: t('.already_exist')) unless application.ssl_certificate.nil?
        params = extract_ssl_certificate(params)
        certificate = application.build_ssl_certificate(params)
        if certificate.save
          application.run_async!('create_lb_route!')
          context.render_success(locals: { application: application })
        else
          disable_ssl(application)
          context.render_failed(locals: { application: application })
        end
      end


      def update_database(application, params = {})
        update_application(application, params) do |application|
          application.run_async!('create_physical_database!')
        end
      end


      def reset_database(application)
        application.run_async!('reset_physical_database!')
        context.render_success(locals: { application: application })
      end


      def synchronize_repository(application, opts = {})
        application.distant_repo.run_async!('resync!', opts)
        context.render_success(locals: { application: application })
      end


      def restore_env_vars(application, params = {})
        execute_action(application, params) do |application|
          application.restore_env_vars!
        end
      end


      def restore_mount_points(application, params = {})
        execute_action(application, params) do |application|
          application.restore_mount_points!
        end
      end


      def reset_ssl_certificate(application, params = {})
        application.ssl_certificate = nil
        disable_ssl(application)
        context.render_success(locals: { application: application })
      end


      def add_addon(application, params = {})
        addon = application.addons.new(params)
        if addon.save
          context.render_success(locals: { application: application })
        else
          context.render_failed(locals: { application: application, addon: addon })
        end
      end


      def toggle_credentials(application, params = {})
        update_boolean_field_if_allowed(application.credentials.any?, application, :use_credentials, params)
      end


      def toggle_ssl(application, params = {})
        update_boolean_field_if_allowed(!application.ssl_certificate.nil?, application, :use_ssl, params)
      end


      def extract_ssl_certificate(params)
        params = read_file_param(params, :ssl_crt)
        params = read_file_param(params, :ssl_key)
        params
      end


      def read_file_param(params, param)
        if params[param] && params[param].is_a?(ActionDispatch::Http::UploadedFile)
          params[param] = params[param].read
        end
        params
      end

    end
  end
end
