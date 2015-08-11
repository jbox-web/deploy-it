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

class RefreshViewEvent

  private_class_method :new

  def initialize(opts = {})
    @data = {}

    @data[:context] = {}
    @data[:context][:controller] = opts.fetch(:controller) { 'applications' }
    @data[:context][:action]     = opts.fetch(:action) { 'show' }
    @data[:context][:app_id]     = opts.fetch(:app_id) { '' }

    triggers         = opts.fetch(:triggers) { [] }
    @data[:triggers] = triggers.map { |t| refresh_view_trigger(t) }
  end


  class << self

    def create(opts = {})
      new(opts).to_h
    end

  end


  def to_h
    @data
  end


  private


    def refresh_view_trigger(url)
      "refreshView('#{url}');"
    end

end
