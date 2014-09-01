require 'rubygems'
require File.join(File.dirname(__FILE__), 'lib/chitter.rb')



use Rack::Session::Cookie
run Rack::Cascade.new [API, Chitter]