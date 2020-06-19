# frozen_string_literal: true
module EasyAPP
  class DataTablePresenter < SimpleDelegator

    def initialize(view, id, opts = {})
      super(view)
      @view       = view
      @id         = id
      @opts       = opts
      @js_method  = 'createDatatable'
      @columns    = []
      @buttons    = []
      @body_opts  = {}
      @search_fields  = []
      @escape_strings = []
    end


    def head(label, opts = {})
      head_for(nil, opts.merge(label: label))
    end


    def head_for(column, opts = {})
      @columns << EasyAPP::DataColumn.new(@view, column, opts)
    end


    def body(opts = {})
      @body_opts = opts
    end


    def button(opts = {})
      @buttons << opts
    end


    def js_method(js_method)
      @js_method = js_method
    end


    def render_datatable
      html_opts = @opts.delete(:html) { {} }
      options = html_opts.merge({ id: id, data: datatable_options.merge(@opts) })
      content_tag(:table, table_content, options)
    end


    def render_js_datatable
      raw("#{@js_method}('##{id}', #{search_fields});")
    end


    def search_form(options = {}, &block)
      options.reverse_merge!({ builder: SearchFormBuilder })
      options[:html] ||= {}
      options[:html][:role] ||= 'form'
      options[:acts_like_form_tag] = true
      options[:datatable] = self

      layout = case options[:layout]
        when :inline
          "form-inline"
        when :horizontal
          "form-horizontal"
      end

      if layout
        options[:html][:class] = [options[:html][:class], layout].compact.join(" ")
      end

      form_for('', options, &block)
    end


    def search_field(field)
      @search_fields << field
    end


    def escape_strings(strings)
      @escape_strings += strings
    end


    private


      def id
        "#{@id}-table"
      end


      def table_content
        table_headers + table_body
      end


      def table_body
        content_tag(:tbody, '', @body_opts)
      end


      def table_headers
        content_tag(:thead, table_row)
      end


      def table_row
        content_tag(:tr, @columns.map(&:to_s).join.html_safe)
      end


      def search_fields
        fields = @search_fields.to_json
        @escape_strings.uniq.each do |str|
          fields = fields.gsub(str.quote, str.unquote)
        end
        fields
      end


      def datatable_options
        {
          processing:   true,
          server_side:  true,
          state_save:   true,
          responsive:   true,
          page_length:  10,
          length_menu:  [[10, 25, 50, 100], [10, 25, 50, 100]],
          paging_type:  'simple_numbers',
          dom:          'lfrtip',
          order:        [],
          language:     datatables_translations,
          columns:      datatable_columns,
          buttons:      @buttons,
        }
      end


      def datatable_columns
        data = []
        @columns.each_with_index do |c, i|
          data << { data: i }.merge(c.to_hash)
        end
        data
      end

  end
end
