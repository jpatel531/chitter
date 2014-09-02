Feature: signing up
	In order to cheet
	I have to sign up as a user

	Scenario: signing up
		Given that I am on the homepage
		And I enter an email and password
		Then I should see a welcome message

	Scenario: with an email that's already been taken
		Given that I am on the homepage
		And an email has already been taken
		And I enter an email and password
		Then I should be told the email has already been taken

	Scenario: with non-matching passwords
		Given that I am on the homepage
			And I enter an email and non-matching password
			Then I should be told my passwords don't match
