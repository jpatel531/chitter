require 'data_mapper'
require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/partial'
require 'haml'
require 'grape'
require 'json'
require_relative 'cheet'
require_relative 'user'
require_relative 'data_mapper_setup'
require_relative 'entities'

class Chitter < Sinatra::Base

	enable :sessions
	set :session_secret, 'super secret encryption key'
	set :partial_template_engine, :haml
	set :public_folder, 'public'
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
		@user = User.create(email: params[:register_email],
			password: params[:register_password],
			:password_confirmation => params[:register_password_confirmation])
		if @user.save
			session[:user_id] = @user.id
			flash[:message] = "Welcome #{@user.email}"
			redirect '/'
		else
			flash[:errors] = @user.errors.full_messages
			redirect '/'
		end
	end

	post '/sessions' do 
		email, password = params[:login_email], params[:login_password]
		user = User.authenticate(email, password)
		if user
			session[:user_id] = user.id
			flash[:message] = "Welcome #{user.email}"
			redirect '/'
		else
			flash[:errors] = ["The email or password is incorrect"]
			redirect '/'
		end
	end

	delete '/sessions/logout' do 
		flash.now[:message] = "Good bye!"
		session[:user_id] = nil
		redirect '/'
	end

	post '/cheets', provides: :json do
		response['Access-Control-Allow-Origin'] = '*'
		data = JSON.parse(request.body.read)
		cheet = Cheet.create(text: data["cheet"], user: current_user, timestamp: Time.now)
		current_user.cheets << cheet
	end

  run! if app_file == $0
end


class ChitterAPI < Grape::API

	format :json

	get :cheets do
		cheets = Cheet.all(order: [:timestamp.desc])
		present cheets, with: API::Entities::Cheet
	end


	  
end