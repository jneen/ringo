class Object
  def metaclass
    class << self
      self
    end
  end

  def meta_eval(&blk)
    self.metaclass.class_eval &blk
  end

  def meta_def(name, &blk)
    self.meta_eval { define_method(name, &blk) }
  end

  def try
    if block_given?
      begin
        yield
      rescue
        nil
      end
    else
      TryProxy.new(self)
    end
  end
end

class TryProxy
  def initialize(obj)
    @obj = obj
  end

  def method_missing(m, *args, &blk)
    if @obj.respond_to? m
      @obj.send(m, *args, &blk)
    else
      nil
    end
  end
end
