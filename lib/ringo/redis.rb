module Ringo
  def self.redis(options={})
    @redis ||= Redis.new(options)
  end
end
