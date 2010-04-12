module Ringo
  class Model
    class RedisProxyWithField
      def initialize(model, type, field_class)
        @field_class = field_class.new
        @type = type
      end
    end

    class RedisProxyField < Field
      def initialize(model, slug)
        @model = model
        @slug = slug
        @model.class_eval <<-code
          def #{slug}
            RedisProxyWithField.new(self, '#{self.type}', #{data_type}
          end
        code
      end
    end
  end
end
