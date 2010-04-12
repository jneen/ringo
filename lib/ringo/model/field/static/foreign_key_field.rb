module Ringo
  class Model
    class ForeignKeyField < StaticField
      def initialize(reference_model, as, *args)
        @reference = reference_model
        @related_name = as
        super(*args)
      end

      def get_filter(obj, id)
        val = @reference[id]
        #p val.instance_variable_get("@id")
        val
      end

      def set_filter(model_obj, foreign_obj)
        unless foreign_obj.is_a? @reference
          (raise TypeError,
            "Foreign key #{self.class.name}##{@slug} expected #{foreign_obj} to be a #{@reference}"
          )
        end
        foreign_obj.id
      end

      def set(obj, val)
        foreign_obj = super

        # take care of the mirrored relation without
        # invoking an infinite loop of doom
        obj.instance_variable_set("@#{@slug}", val)

        mirror = foreign_obj.send(@related_name)
        p ["mirror", mirror]
        p ["obj", obj]
        puts

        unless mirror && mirror == obj
          foreign_obj.send("#{@related_name}=", obj)
        end
      end

    end

    def self.has_one(model, options={})
      as = (options[:as] || self.name.to_underscores).to_sym
      called = (options[:called] || model.name.to_underscores).to_sym

      self.fields[called] = ForeignKeyField.new(model, as, self, called)
      model.fields[as] = ForeignKeyField.new(self, called, model, as)
    end
  end
end
