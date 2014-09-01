class Cheet

	include DataMapper::Resource

	property :id, Serial
	property :text, Text, required: true

	belongs_to :user

end