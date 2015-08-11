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
  module ClassMethods

    def crudify(model_name, opts = {})
      options ||= Crudify::Base.default_options(model_name).deep_merge!(opts)

      class_name    = options[:class_name]
      singular_name = options[:singular_name]
      plural_name   = options[:plural_name]
      namespace     = !options[:namespace].nil? ? "#{options[:namespace]}_" : ''

      finder        = Crudify::Finder.new(singular_name, options[:find])
      strong_params = Crudify::Params.new(singular_name, options[:params])
      breadcrumbs   = Crudify::Breadcrumb.new(namespace, options)


      module_eval %(
        class << self

          def crudify_options
            #{options.inspect}
          end

        end


        prepend_before_action #{finder.render}
        prepend_before_action :set_page_title


        def index
          @#{plural_name} = #{class_name}.all
          add_breadcrumbs
        end


        def show
          render_404
        end


        def new
          @#{singular_name} = #{class_name}.new
          add_breadcrumbs
        end


        def edit
          add_breadcrumbs
        end


        def create
          @#{singular_name} = #{class_name}.new(create_#{singular_name}_params)

          if @#{singular_name}.save
            successful_create
          else
            add_breadcrumbs
            failed_create
          end
        end


        def update
          if @#{singular_name}.update(update_#{singular_name}_params)
            successful_update
          else
            add_breadcrumbs
            failed_update
          end
        end


        def destroy
          if @#{singular_name}.destroy
            successful_delete
          else
            failed_delete
          end
        end


        private


          def find_#{singular_name}
            @#{singular_name} = #{class_name}.find(find_params)
          rescue ActiveRecord::RecordNotFound => e
            render_404
          end


          def create_#{singular_name}_params
            #{strong_params.render(:on_create)}
          end


          def update_#{singular_name}_params
            #{strong_params.render(:on_update)}
          end


          def redirect_url
            #{namespace}#{plural_name}_path
          end


          def find_params
            params[:id]
          end


          def successful_create
            redirect_to redirect_url, notice: t('.notice')
          end


          def successful_update
            redirect_to redirect_url, notice: t('.notice')
          end


          def successful_delete
            redirect_to redirect_url, notice: t('.notice')
          end


          def failed_create
            render :new
          end


          def failed_update
            render :edit
          end


          def failed_delete
            redirect_to redirect_url, alert: @#{singular_name}.errors.full_messages
          end


          def add_breadcrumbs_for(action)
            add_breadcrumbs(action: action.to_s)
          end


          def add_breadcrumbs(action: action_name)
            case action
            when 'index'
              #{breadcrumbs.render(:index)}
            when 'new'
              #{breadcrumbs.render(:new)}
            when 'edit'
              #{breadcrumbs.render(:edit)}
            when 'create'
              #{breadcrumbs.render(:create)}
            when 'update'
              #{breadcrumbs.render(:update)}
            else
              ''
            end
          end


          def set_page_title
            @page_title =
              case self.action_name
              when 'index'
                [#{class_name}.model_name.human(count: 2)]
              when 'new', 'create'
                [t('.title')]
              when 'edit', 'update'
                [t('.title'), @#{singular_name}.to_s]
              else
                ['']
              end
          end

      )
    end

  end
end
