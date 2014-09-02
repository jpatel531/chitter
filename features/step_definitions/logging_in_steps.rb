require 'launchy'

Given(/^I am a registered user$/) do
	@user = User.create(email: "bla@bla.net", password: "12345678", password_confirmation: "12345678")
end

Given(/^I enter a login email and password$/) do
	page.find('.login').click
	fill_in 'login_email', with: 'bla@bla.net'
	fill_in 'login_password', with: '12345678'
	click_button 'Log In'
end
