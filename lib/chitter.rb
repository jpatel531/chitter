require 'data_mapper'
require 'sinatra/base'
require 'grape'
require_relative 'cheet'
require_relative 'data_mapper_setup'

class Chitter < Sinatra::Base

	enable :sessions
	set :session_secret, 'super secret encryption key'
	set :partial_template_engine, :haml


  get '/' do
    'Hello chitter!'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end


class API < Grape::API

	format :json

	  get :hello do
	    {hello: "world"}
	  end
end