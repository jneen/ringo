module Ringo
  class Model
    class StaticField < Field
      def initialize(model=nil, slug=nil)
        @model = model
        @slug = slug
        if @model
          model.class_eval <<-code
            def #{slug}
              return nil unless @#{slug} || @id
              @#{slug} || self.fetch_#{slug}
            end

            def fetch_#{slug}
              @#{slug} = self.class.fields[:#{slug}].get(self)
            end

            def #{slug}=(val)
              @#{slug} = self.class.fields[:#{slug}].set(self, val)
            end
          code
        end
      end

      def get(obj)
        get_filter(obj, redis.get(key_for(obj)))
      end

      def set(obj, val)
        val = set_filter(obj, val)
        redis.set(key_for(obj), val)
        get_filter(obj, val)
      end
    end
  end
end

require 'ringo/model/field/static/string_field.rb'
require 'ringo/model/field/static/foreign_key_field.rb'
