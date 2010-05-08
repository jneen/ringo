require 'rubygems'
require 'active_support/inflector'
require 'redis'

module Ringo
  LIB = File.expand_path(File.dirname(__FILE__))
  ROOT = File.expand_path(File.join(LIB, '..'))
  VENDOR = File.expand_path(File.join(ROOT, 'vendor'))

  def self.key(*args)
    (['ringo'] + args.map {|a| a.to_s}).join(':')
  end
end

require File.expand_path(File.join( 
  File.dirname(__FILE__),
  '../vendor/mock_redis/lib/mock_redis.rb'
))
require 'ringo/core_ext.rb'
require 'ringo/redis.rb'
require 'ringo/model.rb'
