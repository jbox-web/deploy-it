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

module ApplicationHelper

  def html_title(*title)
    content_for(:title, title.join(' - '))
  end


  def can?(permission, application, opts = {}, &block)
    current_user.allowed_to?(permission, application, opts, &block)
  end


  def available_locales
    I18n.available_locales.map { |l| [t("language.name.#{l}"), l] }
  end


  def stock_chart(data_source, options = {})
    chartkick_chart 'StockChart', data_source, options
  end

end
