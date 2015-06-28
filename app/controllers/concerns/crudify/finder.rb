module Crudify
  class Finder

    attr_reader :singular_name
    attr_reader :params


    def initialize(singular_name, params = {})
      @singular_name = singular_name
      @params        = params
    end


    def render
      ":find_#{singular_name}, #{render_find_options}"
    end


    def render_find_options
      params[:except].any? ? find_params_for(:except) : find_params_for(:only)
    end


    def find_params_for(type)
      find = params[type].map{ |p| ":#{p}" }.join(',')
      "#{type}: [#{find}]"
    end

  end
end
