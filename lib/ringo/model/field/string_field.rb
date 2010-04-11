module Ringo
  class Model
    class StringField < Field
      def get(key)
        super.to_s
      end

      def save!(key, val)
        redis.set(key, val.to_s)
      end
    end

    field_type :string, StringField
  end
end
