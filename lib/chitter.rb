require 'data_mapper'
require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/partial'
require 'haml'
require 'grape'
require_relative 'cheet'
require_relative 'data_mapper_setup'

class Chitter < Sinatra::Base

	enable :sessions
	set :session_secret, 'super secret encryption key'
	set :partial_template_engine, :haml
	register Sinatra::Flash


  get '/' do
    haml :index
  end

  post '/users' do 
	@user = User.create(email: params[:email],
		password: params[:password],
		:password_confirmation => params[:password_confirmation])
	if @user.save
		session[:user_id] = @user.id
		flash.now[:message] = "Welcome #{@user.email}"
		redirect '/'
	else
		flash.now[:errors] = @user.errors.full_messages
		erb :"users/new"
	end
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