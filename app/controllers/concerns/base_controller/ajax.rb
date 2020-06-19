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

module BaseController
  module Ajax
    extend ActiveSupport::Concern

    def render_ajax_redirect(url)
      respond_to do |format|
        format.js { render js: "window.location = #{url.to_json};" }
      end
    end


    def render_ajax_response(template: action_name, locals: {})
      respond_to do |format|
        format.js { render ajax_template_path(template), locals: locals }
      end
    end


    def get_controller_name
      self.class.name.gsub('Controller', '').underscore
    end


    def ajax_template_path(template, dir = 'ajax')
      File.join(get_controller_name, dir, template)
    end


    def render_modal_box(locals: {})
      render layout: modal_or_application_layout, locals: locals
    end


    def modal_or_application_layout
      request.xhr? ? 'modal' : 'application'
    end


    def render_multi_responses(template: action_name, partial: action_name, locals: {})
      respond_to do |format|
        format.html { render template, locals: locals }
        format.js   { render 'common/ajax', locals: {}.merge(locals: locals, partial: partial) }
      end
    end

  end
end
