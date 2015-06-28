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
