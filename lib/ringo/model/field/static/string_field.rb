module Ringo
  class Model
    class StringField < StaticField
      def get_filter(val)
        val.to_s
      end

      def set_filter(val)
        val.to_s
      end
    end

    field_type(:string, StringField)
  end
end
