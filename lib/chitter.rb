require 'data_mapper'
require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/partial'
require 'haml'
require 'grape'
require_relative 'cheet'
require_relative 'user'
require_relative 'data_mapper_setup'

class Chitter < Sinatra::Base

	enable :sessions
	set :session_secret, 'super secret encryption key'
	set :partial_template_engine, :haml
	register Sinatra::Flash
	use Rack::MethodOverride

	helpers do 
		def current_user
			@current_user ||= User.get(session[:user_id]) if session[:user_id]
		end
	end


  get '/' do
    haml :index
  end

  post '/users' do 
  	# puts params.inspect
	@user = User.create(email: params[:register_email],
		password: params[:register_password],
		:password_confirmation => params[:register_password_confirmation])
	if @user.save
		session[:user_id] = @user.id
		flash.now[:message] = "Welcome #{@user.email}"
		haml :index
	else
		flash.now[:errors] = @user.errors.full_messages
		haml :index
	end
  end

	post '/sessions' do 
		puts params.inspect
		email, password = params[:login_email], params[:login_password]
		user = User.authenticate(email, password)
		if user
			session[:user_id] = user.id
			flash.now[:message] = "Welcome #{user.email}"
			haml :index
		else
			flash.now[:errors] = ["The email or password is incorrect"]
			haml :index
		end
	end

	delete '/sessions/logout' do 
		puts "HELLO WORLD!!!!!"
		flash.now[:message] = "Good bye!"
		session[:user_id] = nil
		redirect '/'
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