module Crudify
  class Breadcrumb

    attr_reader :singular_name
    attr_reader :plural_name
    attr_reader :namespace
    attr_reader :crumbs_opts


    def initialize(singular_name, plural_name, namespace, crumbable = false, crumbs_opts = {})
      @singular_name = singular_name
      @plural_name   = plural_name
      @namespace     = namespace
      @crumbable     = crumbable
      @crumbs_opts   = crumbs_opts
    end


    def crumbable?
      @crumbable
    end


    def render(type)
      crumbable? ? render_crumbs(type) : ''
    end


    def render_crumbs(type)
      global_crumb.concat(self.send("render_crumbs_for_#{type}")).join("\n")
    end


    def render_crumbs_for_index
      []
    end


    def render_crumbs_for_new
      [ "add_crumb #{crumb_title_for_new}, #{crumb_path_for_new}" ]
    end


    def render_crumbs_for_edit
      [ "add_crumb #{crumb_title_for_object}, #{crumb_path_for_object}", "add_crumb #{crumb_title_for_edit}, #{crumb_path_for_edit}" ]
    end


    def global_crumb
      [ "add_crumb #{global_crumb_title}, #{global_crumb_path}" ]
    end


    ## ALL
    def global_crumb_path
      "#{namespace}#{plural_name}_path"
    end


    def global_crumb_title
      global_crumb_icon.nil? ? global_crumb_title_without_icon : global_crumb_title_with_icon
    end


    def global_crumb_title_without_icon
      "t('label.#{singular_name}.plural')"
    end


    def global_crumb_title_with_icon
      "view_context.label_with_icon(#{global_crumb_title_without_icon}, '#{global_crumb_icon}', fixed: true)"
    end


    def global_crumb_icon
      crumbs_opts[:icon]
    end


    ## NEW / CREATE
    def crumb_title_for_new
      "t('label.#{singular_name}.new')"
    end


    def crumb_path_for_new
      static_link
    end


    ## EDIT / UPDATE
    def crumb_title_for_object
      "@#{singular_name}.to_s"
    end


    def crumb_path_for_object
      static_link
    end


    def crumb_title_for_edit
      "t('label.edit')"
    end


    def crumb_path_for_edit
      static_link
    end


    def static_link
      "'#'"
    end


    alias_method :render_crumbs_for_create, :render_crumbs_for_new
    alias_method :render_crumbs_for_update, :render_crumbs_for_edit
  end
end
