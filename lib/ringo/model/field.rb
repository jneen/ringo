module Ringo
  
  class Model
    def self.fields
      @fields ||= {}
    end

    class Field
      def redis
        Ringo.redis
      end

      def initialize(model, slug)
        @model = model
        @slug = slug
        model.class_eval <<-code
          def #{slug}
            return nil unless @#{slug} || @id
            @#{slug} ||= self.class.fields[:#{slug}].get_by_id(@id)
          end

          def #{slug}=(val)
            @#{slug} = val.to_s
          end
        code
      end

      def key_for(id)
        @model.key(id, @slug)
      end

      def get_by_id(id)
        self.get(self.key_for(id))
      end

      def get(key)
        redis.get(key)
      end
    end
  end
end

require 'ringo/model/field/string_field.rb'
require 'ringo/model/field/int_field.rb'
