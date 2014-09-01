require 'grape-entity'


module API
	module Entities
		class Cheet < Grape::Entity
			expose :text
			expose :user_email
			expose :timestamp
		end


	end
end