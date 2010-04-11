module Ringo
  ROOT = File.expand_path(File.dirname(__FILE__))
  def key(*args)
    (['ringo'] + args.map {|a| a.to_s}).join(':')
  end
end

require File.expand_path(File.join( 
  File.dirname(__FILE__),
  '../vendor/redis-rb/lib/redis'
))
require 'ringo/core_ext.rb'
require 'ringo/redis.rb'
require 'ringo/model.rb'
