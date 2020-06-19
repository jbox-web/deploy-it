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

module BelongsToPlatform
  extend ActiveSupport::Concern

  included do
    before_action :set_platform
  end


  def index
    render_404
  end


  def show
    render_404
  end


  private


    def set_platform
      @platform = Platform.find(params[:platform_id])
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end


    def render_success
      redirect_to admin_platforms_path, notice: t('.notice')
    end


    def render_failed(object)
      redirect_to admin_platforms_path, alert: object.errors.full_messages
    end


    def add_breadcrumbs(object, action: action_name)
      global_crumbs

      case action
      when 'new', 'create'
        add_crumb t('.title'), '#'
      when 'edit', 'update'
        add_crumb object.to_s, '#'
      end
    end


    def global_crumbs
      add_crumb label_with_icon(Platform.model_name.human(count: 2), 'fa-sitemap', fixed: true), admin_platforms_path
      add_crumb @platform.name, admin_platforms_path
    end

end
