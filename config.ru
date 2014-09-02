require 'rubygems'
require 'sinatra'

require './lib/chitter'


run Rack::Cascade.new [ChitterAPI, Chitter]