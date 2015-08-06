module Crudify
  module ClassMethods

    def crudify(model_name, opts = {})
      options ||= Crudify::Base.default_options(model_name).deep_merge!(opts)

      class_name    = options[:class_name]
      singular_name = options[:singular_name]
      plural_name   = options[:plural_name]
      namespace     = !options[:namespace].nil? ? "#{options[:namespace]}_" : ''

      finder        = Crudify::Finder.new(singular_name, options[:find])
      breadcrumbs   = Crudify::Breadcrumb.new(singular_name, plural_name, namespace, options[:crumbable], options[:crumbs_opts])
      strong_params = Crudify::Params.new(singular_name, options[:params])

      module_eval %(
        class << self

          def crudify_options
            #{options.inspect}
          end

        end

        prepend_before_action #{finder.render}


        def index
          @#{plural_name} = #{class_name}.all
          breadcrumbs_for_index
        end


        def show
          render_404
        end


        def new
          @#{singular_name} = #{class_name}.new
          breadcrumbs_for_new
        end


        def edit
          breadcrumbs_for_edit
        end


        def create
          @#{singular_name} = #{class_name}.new(create_#{singular_name}_params)

          breadcrumbs_for_create

          if @#{singular_name}.save
            successful_create
          else
            failed_create
          end
        end


        def update
          breadcrumbs_for_update

          if @#{singular_name}.update(update_#{singular_name}_params)
            successful_update
          else
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
            redirect_to redirect_url, notice: t('notice.#{singular_name}.created')
          end


          def successful_update
            redirect_to redirect_url, notice: t('notice.#{singular_name}.updated')
          end


          def successful_delete
            redirect_to redirect_url, notice: t('notice.#{singular_name}.deleted')
          end


          def failed_create
            render :new
          end


          def failed_update
            render :edit
          end


          def failed_delete
            errors = [ t('error.#{singular_name}.failed_delete') ].concat(@#{singular_name}.errors.full_messages)
            redirect_to redirect_url, alert: errors
          end


          def breadcrumbs_for_index
            #{breadcrumbs.render(:index)}
          end


          def breadcrumbs_for_new
            #{breadcrumbs.render(:new)}
          end


          def breadcrumbs_for_edit
            #{breadcrumbs.render(:edit)}
          end


          def breadcrumbs_for_create
            #{breadcrumbs.render(:create)}
          end


          def breadcrumbs_for_update
            #{breadcrumbs.render(:update)}
          end
      )
    end

  end
end
