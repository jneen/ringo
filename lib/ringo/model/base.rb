module Ringo
  class Model

    ## class methods
    class << self
      def find(id)
        self.new(:id => id)
      end
      alias [] find

      def slug
        self.name.underscore.pluralize
      end

      def key(*args)
        Ringo.key(self.slug, *args)
      end

      def last_id
        Ringo.redis[self.key('__id__')].to_i
      end
    end


    ## instance methods

    def initialize(attrs={})
      if attrs.include? :id
        @id = attrs[:id].to_i
        attrs.delete :id
      end

      attrs.each do |slug, val|
        if self.class.fields.include? slug
          self.send(:"#{slug}=", val)
        end
      end
    end

    def id
      @id ||= Ringo.redis.incr(self.class.key('__id__')).to_i
    end

    def ==(other)
      self.class == other.class &&
      self.id == other.id
    end

  end
end
