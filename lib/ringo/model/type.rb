module Ringo
  class Type
    class Error < TypeError; end

    def self.types
      @types ||= {}
    end

    def self.declare_with(*method_names)
      type_class = self
      method_names.each do |name|
        if self.types.include? name
          raise Error, "A type (#{Type.types[name]}) declared with :#{name} already exists!"
        end
        Type.types[name] = self

        # define the type methods on Model.  This allows
        # class Foo < Ringo::Model
        #   #{name} :bar
        # end
        # foo = Foo.new
        # foo.bar # => type.default
        # foo.bar = :something
        # foo.bar # => :something
        Model.meta_def name do |attr, *opts|
          attr = attr.to_sym
          attr_equals = :"#{attr}="
          at_attr = "@#{attr}"
          type = type_class.new(*opts)

          define_method attr do
            key = self.key(attr)
            puts "getting #{attr.inspect} from #{key.inspect}"
            unless Ringo.redis.exists(key)
              return self.instance_variable_set(at_attr, type.default)
            end
            redis_val = Ringo.redis.get(key)
            instance_variable_set(at_attr, type.get_filter(redis_val))
          end

          define_method attr_equals do |val|
            key = self.key(attr)
            redis_val = type.set_filter(val)
            Ringo.redis.set(key, redis_val)
            self.instance_variable_set(at_attr, type.get_filter(redis_val))
          end
        end

        Model.private_class_method(name)
      end
    end

    attr_reader :default

    def initialize(opts={})
      @default = opts.delete(:default) || nil
      try.post_initialize(opts)
    end
  end
end

require 'ringo/model/type/int.rb'
require 'ringo/model/type/string.rb'
require 'ringo/model/type/reference.rb'
