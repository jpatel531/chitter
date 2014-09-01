Feature: In order to let people know what I am doing
	As a user
	I want to post a message to Chitter

	Background: logged in
		Given that I am on the homepage
		And I am a registered user
		And I enter a login email and password

		@javascript
		Scenario: posting a cheet
			When I enter a cheet and press submit
			Then I should see the cheet on the page



