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
        self.name.underscore.pluralize
      end

      def key(*args)
        Ringo.key(self.slug, *args)
      end

      def last_id
        Ringo.redis[self.key('__id__')].to_i
      end

      def before(sym, options={}, &blk)
        mth = options[:receives] || :__all__
        before_hooks[sym] ||= {}
        before_hooks[sym][mth] ||= []
        before_hooks[sym][mth] << blk
        puts before_hooks.inspect
      end

      def after(sym, options={}, &blk)
        mth = options[:receives] || :__all__
        after_hooks[sym] ||= {}
        after_hooks[sym][mth] ||= []
        after_hooks[sym][mth] << blk
      end

      def before_hooks
        @before_hooks ||= {}
      end

      def after_hooks
        @after_hooks ||= {}
      end
        
    end

    def run_before_hooks(sym, mth, *args)
      return unless self.class.before_hooks[sym] && self.class.before_hooks[sym][mth]
      self.class.before_hooks[sym][mth].each do |blk|
        blk.call(self, *args)
      end
    end

    def run_after_hooks(sym, mth, *args)
      return unless self.class.before_hooks[sym] && self.class.before_hooks[sym][mth]
      self.class.before_hooks[sym][mth].each do |blk|
        blk.call(self, *args)
      end
    end

    def with_hooks(sym, mth, *args)
      self.run_before_hooks(sym, mth, *args)
      yield if block_given?
      self.run_after_hooks(sym, mth, *args)
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
      @id ||= redis.incr(self.class.key('__id__')).to_i
    end

    def ==(other)
      self.class == other.class &&
      self.id == other.id
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
