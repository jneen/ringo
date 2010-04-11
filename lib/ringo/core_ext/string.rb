class String
  def to_underscores!
    self #TODO
  end

  def to_underscores
    self.dup #TODO
  end

  def to_camel_case!
    self #TODO
  end

  def to_camel_case
    self.dup #TODO
  end

  def pluralize(num)
    #TODO
    if num == 1
      self
    else
      self + 's'
    end
  end
end
