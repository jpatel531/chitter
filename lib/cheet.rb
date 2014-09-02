class Cheet

	include DataMapper::Resource

	property :id, Serial
	property :text, Text, required: true
	property :timestamp, DateTime

	validates_length_of :text, max: 140

	belongs_to :user

	def user_email
		user.email
	end


end