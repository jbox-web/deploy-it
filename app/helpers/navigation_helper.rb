module NavigationHelper

  def render_navigation_menu(context)
    options = bootstrap_menu_options.merge(context: context)
    render_navigation(options)
  end


  def bootstrap_menu_options
    { renderer: :bootstrap3, expand_all: true, remove_navigation_class: true, skip_if_empty: true }
  end


  def menu_entry_for_model(model, opts = {})
    [{ icon: icon_for_entry(model.constantize.model_icon_name), text: label_for_entry(get_model_name_for(model)) }, url_for_entry(model, opts)]
  end


  def icon_for_entry(icon)
    "fa fa-fw #{icon}"
  end


  def label_for_entry(label)
    content_tag(:span, label, class: 'nav-label')
  end


  def url_for_entry(model, opts = {})
    klass = model.constantize
    namespace = opts.delete(:namespace) { nil }
    url_for([namespace, klass.new].compact)
  end


  def render_user_menu(menu)
    menu.item :logged, wrapped_nav_header, '#', html: { class: 'nav-header', wrapper: ->(o) { wrap_header_with_image(o) }, skip_caret: true }, link_html: { data: { toggle: 'dropdown' }, class: 'dropdown-toggle' }, highlights_on: %r{//} do |sub_menu|
      sub_menu.dom_class = 'animated fadeInRight m-t-xs'
      sub_menu.item :my_account, t('text.my_account'), my_account_path, highlights_on: %r{//}
    end
  end


  def wrapped_nav_header
    content_tag(:span, class: 'clear') do
      content_tag(:span, content_tag(:strong, current_user.to_s, class: 'font-bold'), class: 'block m-t-xs') +
      content_tag(:span, "#{current_user} #{caret}".html_safe, class: 'text-muted text-xs block')
    end
  end


  def wrap_header_with_image(content)
    content_tag(:div, class: 'dropdown profile-element') do
      content_tag(:span, image_tag(avatar_url(current_user), class: 'img-circle', alt: 'image')) + content
    end
  end


  def avatar_url(user)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "https://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=retro"
  end


  def caret
    content_tag(:b, '', class: 'caret')
  end


  def menu_divider
    ['', '#', html: { divider: true, class: 'divider-horizontal' }, highlights_on: %r(//)]
  end


  def locals_for(menu, &block)
    @locals_for ||= {}
    if block_given?
      @locals_for[menu] = block
    else
      @locals_for[menu]
    end
  end

end
