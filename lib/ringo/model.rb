module Ringo
  class Model < Rudis::Base
    
    # -*- class methods -*- #
    class << self
      def attrs(hsh={})
        @attrs ||= {}
        @attrs.merge!(hsh)
      end

      def attr(name, type)
        attrs[name] = type
      end

      def inherited(kl)
        kl.key_base << kl.name
      end

      def find(id)
        new(:id => id)
      end
    end


    # -*- instance methods -*- #
    
    attr_reader :id
    def initialize(attrs={})
      @id = attrs.delete(:id)
      __hash__.merge!(attrs)
    end

    def to_h
      __hash__.map_keys(&:to_sym).merge(:id => @id)
    end

    def [](k)
      __hash__[k.to_s]
    end

    def []=(k,v)
      __hash__[k.to_s] = v
    end

    def key(*args)
      self.class.key(:objects, @id, *args)
    end

    def save!
      #TODO: validation
      return if __hash__.empty?

      dumped_hash = __hash__.map do |k,v|
        [k, type_for(k).dump(v)]
      end.flatten

      get_id
      p dumped_hash
      redis.hmset(key, *dumped_hash)
    end

    def saved?
      !@id.nil?
    end

    def last_id
      id_counter.to_i
    end

  private
    def id_counter
      @id_counter ||= Rudis::Counter.new self.class.key(:id_counter)
    end

    def get_id
      @id ||= id_counter.incr
    end

    def type_for(k)
      self.class.attrs[k.to_sym]
    end

    # this method does most of the heavy lifting.
    def __hash__
      @__hash__ ||= if saved?
        Hash.new do |hsh, k|
          if self.class.attrs.include? k.to_sym
            h = redis.hgetall(key(:objects, @id)).map do |k,v|
              [k, type_for(k).load(v)]
            end.to_h
            hsh.rmerge!(h)
            hsh[k]
          else
            raise ArgumentError, "Unknown attribute #{k} for #{self.inspect}"
          end
        end
      else
        {}
      end
    end
  end
end

#require 'ringo/model/base.rb'
#require 'ringo/model/field.rb'
#require 'ringo/model/type.rb'
#require 'ringo/model/redis_type.rb'
