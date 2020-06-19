# frozen_string_literal: true
module EasyAPP
  class SearchFormBuilder < BootstrapForm::FormBuilder

    def initialize(object_name, object, template, options)
      @datatable = options[:datatable]
      super
    end


    def search_field(name, opts = {}, container_opts = {})
      opts = opts.merge(filter_type: 'text', filter_container_id: name)
      container_opts = container_opts.merge(id: name)
      escape_strings = opts.delete(:escape_strings){ [] }
      @datatable.escape_strings(escape_strings)
      @datatable.search_field(opts)
      content_tag(:div, '', container_opts)
    end


    def select(name, opts = {}, container_opts = {})
      opts = opts.deep_merge(filter_type: 'select')
      select_field(name, opts, container_opts)
    end


    def multi_select(name, opts = {}, container_opts = {})
      opts = opts.deep_merge(filter_type: 'multi_select')
      select_field(name, opts, container_opts)
    end


    def range_date(name, opts = {}, container_opts = {})
      opts = opts.merge(filter_type: 'range_date', filter_container_id: name)
      container_opts = container_opts.merge(id: name)
      @datatable.search_field(opts)
      content_tag(:div, '', container_opts)
    end


    def render_datatable
      @datatable.render_datatable
    end


    def render_js_datatable
      @datatable.render_js_datatable
    end


    private


      def select_field(name, opts = {}, container_opts = {})
        escape_strings = opts.delete(:escape_strings){ [] }
        opts = opts.deep_merge(filter_container_id: name, select_type: 'select2')
        container_opts = container_opts.merge(id: name)
        @datatable.escape_strings(escape_strings)
        @datatable.search_field(opts)
        content_tag(:div, '', container_opts)
      end

  end
end
