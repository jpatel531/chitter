require 'rubygems'
require 'sinatra'
require File.join(File.dirname(__FILE__), 'lib/chitter.rb')



run Rack::Cascade.new [ChitterAPI, Chitter]