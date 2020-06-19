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
  module UserSettings
    extend ActiveSupport::Concern

    included do
      before_action :setup_locale

      # Set TimeZone for current user
      # Must be in a around_action : Time.zone is NOT request local
      # http://railscasts.com/episodes/106-time-zones-revised?view=comments#comment_162005
      around_action :set_time_zone
    end


    def setup_locale
      I18n.locale = current_site_user.language || I18n.default_locale
    end


    def set_time_zone(&block)
      Time.use_zone(current_site_user.time_zone, &block)
    end


    def reload_user_locales
      current_site_user.reload
      setup_locale
    end

  end
end
