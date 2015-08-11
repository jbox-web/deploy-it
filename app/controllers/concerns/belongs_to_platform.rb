module BelongsToPlatform
  extend ActiveSupport::Concern

  included do
    before_action :set_platform
  end


  def index
    render_404
  end


  def show
    render_404
  end


  private


    def set_platform
      @platform = Platform.find(params[:platform_id])
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end


    def render_success
      redirect_to admin_platforms_path, notice: t('.notice')
    end


    def render_failed(object)
      redirect_to admin_platforms_path, alert: object.errors.full_messages
    end


    def add_breadcrumbs(object, action: action_name)
      global_crumbs

      case action
      when 'new', 'create'
        add_crumb t('.title'), '#'
      when 'edit', 'update'
        add_crumb object.to_s, '#'
      end
    end


    def global_crumbs
      add_crumb label_with_icon(Platform.model_name.human(count: 2), 'fa-sitemap', fixed: true), admin_platforms_path
      add_crumb @platform.name, admin_platforms_path
    end

end
