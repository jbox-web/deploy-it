class BaseMenu < SimpleDelegator

  def initialize(view)
    super(view)
  end


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

end
