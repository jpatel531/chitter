Feature: logging out
	In order to get on with my life
	I must be able to log out

	Scenario: logging out
	Given that I am on the homepage
	And I am a registered user
	And I enter a login email and password
	And I click "Log Out"
	Then I should be invited to log back in