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

module Crudify
  module Base
    extend ActiveSupport::Concern

    included do
      send(:extend, Crudify::ClassMethods)
    end

    class << self

      def default_options(model_name)
        class_name    = "#{model_name.to_s.camelize.gsub('/', '::')}".gsub('::::', '::')
        this_class    = class_name.constantize.base_class
        singular_name = ActiveModel::Naming.param_key(this_class)
        plural_name   = singular_name.pluralize

        {
          class_name:    class_name,
          singular_name: singular_name,
          plural_name:   plural_name,
          namespace:     nil,
          crumbable:     false,
          crumbs_opts:   {},
          params: {
            on_create: [],
            on_update: []
          },
          find: {
            only: [:show, :edit, :update, :destroy],
            except: []
          }
        }
      end

    end

  end
end
