# frozen_string_literal: true
module EasyAPP
  class DataColumn

    def initialize(view, name, opts = {})
      @view = view
      @name = name
      @opts = opts
    end


    def to_s
      @view.content_tag(:th, label, class: css_class)
    end


    def to_hash
      { className: css_class, visible: visible?, orderable: sortable?, searchable: searchable?, width: width, data: @name }
    end


    def label
      @opts.fetch(:label, '')
    end


    def sortable?
      @opts.fetch(:sortable, true)
    end


    def searchable?
      @opts.fetch(:searchable, true)
    end


    def visible?
      @opts.fetch(:visible, true)
    end


    def css_class
      @opts.fetch(:class, @name)
    end


    def width
      @opts.fetch(:width, '')
    end

  end
end
