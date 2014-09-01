require 'grape-entity'


module API
	module Entities
		class Cheet < Grape::Entity
			expose :text
			expose :user_id
			expose :user_email
		end


	end
end