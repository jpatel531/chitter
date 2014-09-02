Feature: logging in
	In order to cheet
	I have to log in

	Scenario: logging in
		Given that I am on the homepage
		And I am a registered user
		And I enter a login email and password
		Then I should see a welcome message

	Scenario: logging in with an incorrect password
		Given that I am on the homepage
		And I am a registered user
		And I enter an incorrect password
		Then I should see an error message