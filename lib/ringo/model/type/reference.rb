module Ringo
  class Reference < Type
    declare_with :reference

    class Error < Type::Error; end

    def post_initialize(opts)
      unless opts.include? :to
        raise Error, "Reference doesn't know what to reference!"
      end

      if opts[:to].is_a?(Symbol) || opts[:to].is_a?(String)
        @reference = Ringo.const_get(opts[:to].to_s.camelcase)
      elsif opts[:to].is_a? Class
        @reference = opts[:to]
      end

      unless @reference.try.descends_from?(Ringo::Model)
        raise Error, <<-msg.squish
          Ringo::Reference expected #{@reference.inspect}
          to be a Ringo::Model!
        msg
      end
    end

    def get_filter(val)
      @reference[val.to_i]
    end

    def set_filter(val)
      unless val.is_a? @reference
        raise Error, <<-msg.squish
          Ringo::Reference expected #{val.inspect} to be a #{@reference}!
        msg
      end
      val.id
    end
  end
end
