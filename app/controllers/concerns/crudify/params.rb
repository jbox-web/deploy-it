module Crudify
  class Params

    attr_reader :singular_name
    attr_reader :params


    def initialize(singular_name, params = {})
      @singular_name = singular_name
      @params        = params
    end


    def render(type)
      options = convert_params_to_symbol(type).join(',')
      "params.require(:#{singular_name}).permit(#{options})"
    end


    def convert_params_to_symbol(type)
      options =
        params[type].map{ |p|
          case p.class.name
          when 'Symbol'
            ":#{p}"
          when 'Hash'
            content = ''
            p.each do |key, values|
             content << "#{key}: #{values}"
            end
            content
          end
        }
      options
    end

  end
end
