class BaseMenu < SimpleDelegator

  USER_CONTROLLERS = [ 'MyController', 'PublicKeysController', 'RegistrationsController' ]


  def initialize(view)
    super(view)
  end


  def current_menu_name
    if admin_section?
      t('label.admin')
    elsif profile_section?
      t('label.my.account')
    elsif welcome_section?
      t('label.help')
    else
      t('label.application.plural')
    end
  end


  private


    def nav_menu(&block)
      proc do |menu|
        menu.dom_class = 'nav navmenu-nav'
        yield menu
      end
    end


    def nav_bar_right(&block)
      proc do |menu|
        menu.dom_class = 'nav navbar-nav navbar-right'
        yield menu
      end
    end


    def render_menu(opts = {}, &block)
      opts = { renderer: :bootstrap3, expand_all: true, remove_navigation_class: true, skip_if_empty: true }.merge(opts)
      # Call simple-navigation rendering method
      filter_menu(render_navigation(opts, &block))
    end


    def filter_menu(menu)
      menu.empty? ? '' : menu
    end


    def welcome_section?
      !admin_section? && !dashboard_section? && !profile_section?
    end


    def admin_section?
      controller.class.name.split("::").first == 'Admin'
    end


    def dashboard_section?
      !USER_CONTROLLERS.include?(controller.class.name) && controller.class.name != 'WelcomeController'
    end


    def profile_section?
      USER_CONTROLLERS.include?(controller.class.name)
    end


    def application_section?
      controller.class.name == 'ApplicationsController'
    end


    def credential_section?
      controller.class.name == 'CredentialsController'
    end

end
