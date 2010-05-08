module Ringo

  class JSONType < Type
    declare_with :json, :json_obj

    def post_initialize
      require 'json'
    end

    def set_filter(val)
      val.to_json
    end

    def get_filter(val)
      JSON.parse(val)
    end

  end
end
