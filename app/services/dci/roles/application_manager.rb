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
    class ApplicationManager < Base

      include ApplicationCommon


      def create(wizard_form, user)
        application = wizard_form.object
        if wizard_form.save
          application.create_relations!(user: user)
          application.run_async!('bootstrap!')
          context.render_success(locals: { application: application })
        else
          context.render_failed(locals: { application: application })
        end
      end


      def destroy(application)
        application.marked_for_deletion = true
        application.save!
        application.run_async!('destroy_forever!')
        context.render_success
      end


      def build_application(application, user, push = nil, opts = {}, &block)
        return context.render_failed(locals: { request_id: nil }, message: I18n.t('errors.deploy_it.unbuildable')) if push.nil?

        # Create a new build, actually a state machine, to handle the request
        build = application.create_build_request!(push, user)

        # Call the BuildManager that performs validation checks and handle the state machine
        task = BuildManager.new(build)

        options = { build_id: build.id, author_id: build.author_id, request_id: build.request_id, revision: build.push.new_revision }
        options = opts.merge(options)

        if task.runnable?
          task.run!(options)
          yield task if block_given?
          context.render_success(locals: { request_id: build.request_id })
        else
          yield task if block_given?
          context.render_failed(locals: { request_id: nil }, message: task.errors)
        end
      end


      def manage_application(application, deploy_action, opts = {})
        application.run_async!(deploy_action.to_method, opts)
        context.render_success
      end


      def manage_container(application, container, deploy_action, opts = {})
        options = { update_route: true }.merge(opts)
        container.run_async!(deploy_action.to_method, options)
        context.render_success
      end

    end
  end
end
