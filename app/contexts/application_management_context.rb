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

class ApplicationManagementContext < SimpleDelegator

  include ApplicationCommon


  def initialize(context)
    super(context)
  end


  def build_application(application, opts = {})
    event_options = opts.fetch(:event_options) { {} }

    push = application.pushes.last
    return render_failed(locals: { request_id: nil }, message: t('.unbuildable')) if push.nil?

    build = application.create_build_request!(push, User.current)
    request_id = build.request_id

    # Call the BuildManager
    task = BuildManager.new(build, logger: 'console_streamer', event_options: event_options, user: User.current)

    if task.runnable?
      task.run!
      render_success(locals: { request_id: request_id })
    else
      render_failed(locals: { request_id: nil }, message: task.errors)
    end
  end


  def manage_application(application, deploy_action, opts = {})
    event_options = opts.fetch(:event_options) { {} }
    application.run_async!(deploy_action.to_method, event_options: event_options)
    render_success
  end


  def manage_container(application, container, deploy_action, opts = {})
    event_options = opts.fetch(:event_options) { {} }
    container.run_async!(deploy_action.to_method, event_options: event_options, job_options: { update_route: true })
    render_success
  end

end
