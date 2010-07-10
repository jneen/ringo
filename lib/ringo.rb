require 'rubygems'
require 'active_support/inflector'

module Ringo
  LIB = File.expand_path(File.dirname(__FILE__))
  ROOT = File.expand_path(File.join(LIB, '..'))
  VENDOR = File.expand_path(File.join(ROOT, 'vendor'))
end

require File.join(Ringo::VENDOR, *'rudis/init'.split('/'))

require_local 'ringo/model'
