module Ringo
  class Model

    ## class methods
    class << self
      def field_type(name, klass)
        meta_def(name) do |slug, *options|
          self.fields[slug] = klass.new(self, slug, *options)
        end
      end

      def find(id)
        self.new(:id => id)
      end
      alias [] find

      def slug
        self.name.to_underscores.pluralize
      end

      def key(*args)
        Ringo.key(self.slug, *args)
      end
    end


    ## instance methods

    def initialize(attrs={})
      if attrs.include? :id
        @id = attrs[:id]
        attrs.delete :id
      end

      attrs.each do |slug, val|
        if self.class.fields.include? slug
          self.send(:"#{slug}=", val)
        end
      end
    end

    def id
      @id ||= redis.incr(self.class.key('__id__'))
    end

    def save!
      self.class.fields.map do |slug, field|
        if (val = instance_variable_get("@#{slug}"))
          field.save!(slug, val)
        end
      end
    end

    #helper method to reduce typing :D
    def self.redis
      Ringo.redis
    end

    def redis
      self.class.redis
    end

  end
end

require 'ringo/model/field.rb'
