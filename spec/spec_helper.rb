$:.unshift(File.expand_path(File.dirname(__FILE__))) unless
    $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
require 'coveralls'
Coveralls.wear!

require 'simplecov'
SimpleCov.minimum_coverage 90 
SimpleCov.start do
  add_filter '/spec/'
  add_filter 'vendor'
end

require 'webmock/rspec'
require 'rspec'
require 'reviewlette'
require 'support/request_stubbing'
require 'debugger'
require 'byebug'


