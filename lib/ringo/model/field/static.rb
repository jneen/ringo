module Ringo
  class Model
    class StaticField < Field
      def initialize(model, slug)
        @model = model
        @slug = slug
        model.class_eval <<-code
          def #{slug}
            return nil unless @#{slug} || @id
            @#{slug} || self.fetch_#{slug}
          end

          def fetch_#{slug}
            @#{slug} = self.class.fields[:#{slug}].get(self.id)
          end

          def #{slug}=(val)
            @#{slug} = self.class.fields[:#{slug}].set(self.id, val)
          end
        code
      end

      def get(id)
        get_filter(redis.get(key_for(id)))
      end

      def set(id, val)
        val = set_filter(val)
        redis.set(key_for(id), val)
        val
      end
    end
  end
end

require 'ringo/model/field/static/string_field.rb'
