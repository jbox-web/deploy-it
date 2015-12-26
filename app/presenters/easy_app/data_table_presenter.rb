module EasyAPP
  class DataTablePresenter < SimpleDelegator

    def initialize(view, id, opts = {})
      super(view)
      @view        = view
      @id          = id
      @opts        = opts
      @columns     = []
      @buttons     = []
      @order       = []
      @dom         = 'lfrtip'
      @source      = nil
      @body_opts   = {}
      @page_length = 10
      @save_state  = true
      @on_created_row = []
      @on_draw        = []
      @on_responsive_display = []
      @search_fields  = []
      @escape_strings = []
    end


    def head(label, opts = {})
      @columns << EasyAPP::DataColumn.new(@view, label, opts)
    end


    def body(opts = {})
      @body_opts = opts
    end


    def button(opts = {})
      @buttons << opts
    end


    def render_datatable
      options = @opts.merge({ id: id, data: { source: @source } })
      content_tag(:table, table_content, options) + datatable_js
    end


    def save_state(state)
      @save_state = state
    end


    def dom(dom)
      @dom = dom
    end


    def order(order)
      @order = order
    end


    def source(source)
      @source = source
    end


    def on_created_row(callbacks)
      @on_created_row = callbacks
    end


    def on_draw(callbacks)
      @on_draw = callbacks
    end


    def on_responsive_display(callbacks)
      @on_responsive_display = callbacks
    end


    def page_length(length)
      @page_length = length
    end


    def search_form(options = {}, &block)
      options.reverse_merge!({ builder: EasyAPP::SearchFormBuilder })
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


      def datatable_js
        javascript_tag do
        raw("
          table = $('##{id}').DataTable({#{datatable_options}});
          yadcf.init(table, #{search_fields}, 'footer');
          $('.yadcf-filter-wrapper').each(function() {
            $(this).children().wrapAll('<div class=\"col-md-12\"></div>').wrapAll('<div class=\"input-group\"></div>');
            return $(this).children().wrapAll('<div class=\"form-group\"></div>');
          });
          $('.yadcf-filter-reset-button').addClass('btn btn-default').wrap('<span class=\"input-group-btn\"></span>');
          $('.yadcf-filter').addClass('form-control');
          #{add_on_responsive_display_callback}
        ")
        end
      end


      def datatable_options
        raw("
          processing:  true,
          serverSide:  true,
          responsive:  true,
          stateSave:   #{@save_state},
          buttons:     #{@buttons.to_json},
          dom:         '#{@dom}',
          order:       #{@order},
          language:    #{datatables_translations.to_json},
          ajax:        $('##{id}').data('source'),
          pagingType:  'full_numbers',
          pageLength:  #{@page_length},
          #{add_on_created_row_callback}
          #{add_on_draw_callback}
          columns:     #{datatable_columns.to_json}
        ")
      end


      def datatable_columns
        data = []
        @columns.each_with_index do |c, i|
          data << { data: i, className: c.css_class, visible: c.visible?, orderable: c.sortable?, searchable: c.searchable? }
        end
        data
      end


      def add_on_created_row_callback
        return '' if @on_created_row.empty?
        raw("createdRow: function(row, data, index) { #{@on_created_row.join(' ')} },")
      end


      def add_on_draw_callback
        return '' if @on_draw.empty?
        raw("drawCallback: function(settings, json) { #{@on_draw.join(' ')} },")
      end


      def add_on_responsive_display_callback
        return '' if @on_responsive_display.empty?
        raw("
          table.on('responsive-display', function (e, datatable, row, showHide, update) {
            #{@on_responsive_display.join(' ')}
          });
        ")
      end

  end
end
