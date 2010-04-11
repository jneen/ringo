module Ringo
  
  class Model
    def self.fields
      @fields ||= {}
    end

    class Field
      def redis
        Ringo.redis
      end

      def key_for(id)
        @model.key(id, @slug)
      end
    end
  end
end

require 'ringo/model/field/static.rb'
require 'ringo/model/field/redis_proxy.rb'
