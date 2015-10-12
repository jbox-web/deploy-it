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

module BaseController::Helpers
  extend ActiveSupport::Concern

  include SmartListing::Helper::ControllerExtensions


  def label_with_icon(*args)
    view_context.label_with_icon(*args)
  end


  def add_breadcrumb(label, icon, url)
    add_crumb label_with_icon(label, icon, fixed: true, bigger: false), url
  end


  def get_model_name_for(klass, pluralize: true)
    count = pluralize ? 2 : 1
    klass.constantize.model_name.human(count: count)
  end


  included do
    helper_method :get_model_name_for
    helper SmartListing::Helper
  end

end
