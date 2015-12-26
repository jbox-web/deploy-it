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

module DeployIt
  class API < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api

    rescue_from ActiveRecord::RecordNotFound do |e|
      error!("404 Not Found", 404)
    end

    before do
      error!("401 Unauthorized", 401) unless authenticated
    end


    helpers do

      def authenticated
        params[:access_token] && User.current = User.find_by_api_token(params[:access_token])
      end

      def render_success
        'OK'
      end

    end


    resource :applications do
      desc "Return applications list."
      get :list do
        ::Application.visible.all
      end
    end


    resource :containers do
      desc "Return containers list."
      get :list do
        ::Application.includes(:containers).visible.map(&:containers)
      end


      params do
        requires :id,      type: String
        requires :type,    type: String
        requires :message, type: String
      end

      post ':id/events' do
        container = Container.find_by_docker_id(params[:id])
        raise ActiveRecord::RecordNotFound if container.nil?
        DCI::Roles::ApplicationManager.new(self).create_container_event(container, { type: params[:type], message: params[:message] })
      end
    end

  end
end
