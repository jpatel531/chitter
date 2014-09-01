class Cheet

	include DataMapper::Resource

	property :id, Serial
	property :text, Text, required: true
	property :timestamp, DateTime

	belongs_to :user

	def user_email
		user.email
	end


end