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

class ChartsController < ApplicationController

  ALLOWED_TYPES  = ['pushes', 'releases']
  ALLOWED_GROUPS = ['month_of_year', 'day_of_week', 'day']

  before_action :set_application
  before_action :authorize
  before_action :set_type
  before_action :set_group_by


  def charts
    render json: compute_chart
  end


  private


    def set_type
      return render_404 unless ALLOWED_TYPES.include?(params[:type])
      @type = params[:type]
    end


    def set_group_by
      return render_404 unless ALLOWED_GROUPS.include?(params[:group_by])
      @group_by = params[:group_by]
    end


    def compute_chart
      case @group_by
      when 'month_of_year'
        @application.send(@type).group_by_month_of_year(:created_at, format: '%b').count
      when 'day_of_week'
        @application.send(@type).group_by_day_of_week(:created_at, format: '%A').count
      when 'day'
        @application.send(@type).group_by_day(:created_at).count
      end
    end

end
