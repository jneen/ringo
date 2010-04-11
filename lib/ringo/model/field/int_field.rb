module Ringo
  class Model
    class IntegerField < StringField
      def get(key)
        super.to_i
      end
    end

    class RedisInteger
      def initialize(int, key)
        @int = int.to_i
        @key = key
      end

      def method_missing(name,*args)
        @int.send(name,*args)
      end
    end

    field_type :int, IntegerField
    field_type :integer, IntegerField
  end
end
