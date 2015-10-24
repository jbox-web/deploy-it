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

module HtmlHelpers
  module HighchartsHelper

    def render_highcharts_translations
      data = {}
      data[:months]       = t(:month_names, scope: :date).compact
      data[:weekdays]     = t(:day_names, scope: :date)
      data[:shortMonths]  = t(:abbr_month_names, scope: :date).compact
      data[:printChart]   = t('highcharts.print')
      data[:downloadJPEG] = t('highcharts.download.jpeg')
      data[:downloadPDF]  = t('highcharts.download.pdf')
      data[:downloadPNG]  = t('highcharts.download.png')
      data[:downloadSVG]  = t('highcharts.download.svg')
      data[:contextButtonTitle] = t('highcharts.menu')
      data.to_json
    end

  end
end
