require 'rubygems'
require 'sinatra'

require_relative 'lib/chitter'


run Rack::Cascade.new [ChitterAPI, Chitter]