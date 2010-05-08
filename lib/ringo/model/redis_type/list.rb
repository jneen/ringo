module Ringo
  class RedisList < RedisType
    declare_with :list
    
    def push(val)
      redis.rpush(self.key, @type.set_filter(val))
    end
    alias << push

    def pop
      p @type
      @type.get_filter(redis.rpop(self.key))
    end

    def unshift(val)
      redis.lpush(self.key, @type.set_filter(val))
    end
    alias >> unshift

    def shift
      @type.get_filter(redis.lpop(self.key))
    end

    def slice(one, two=nil)
      if one.is_a?(Fixnum) && two.nil?
        return @type.get_filter(redis.lindex(self.key, val))
      end

      range = parse_slice_args(one, two)
      redis.lrange(self.key, range.first, range.last).map do |s|
        @type.get_filter(s)
      end
    end


    def trim!(one, two=nil)
      range = parse_slice_args(one, two)
      redis.ltrim(self.key, range.first, range.last)
      true
    end

    def first
      self[0]
    end

    def last
      self[-1]
    end

    def all
      self[0..-1]
    end
    alias to_a all

    def set(k,v)
      redis.lset(self.key, k, @type.set_filter(v))
    end
    alias []= set

    def count
      redis.llen(self.key).to_i
    end
    alias size count
    alias length count

    def empty?
      self.count == 0
    end

    def method_missing(meth, *args, &blk)
      if Array.public_instance_methods.include? meth
        self.to_a.call(meth, *args, &blk)
      else
        super
      end
    end

    private
    def parse_slice_args(one, two=nil)
      if one.is_a? Range
        one
      elsif one.is_a?(Fixnum) && two.is_a?(Fixnum)
        one..(one+two)
      else
        raise ArgumentError, "invalid arguments #{one.inspect}, #{two.inspect} passed to RedisList#slice"
      end
    end
  end
end
