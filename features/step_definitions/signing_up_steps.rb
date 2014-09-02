Given(/^that I am on the homepage$/) do
  visit '/'
end

Given(/^I enter an email and password$/) do
  fill_in 'register_email', with: "bla@bla.net"
  fill_in 'register_password', with: '12345678'
  fill_in 'register_password_confirmation', with: '12345678'
  click_button 'Sign Up'
end

Then(/^I should see a welcome message$/) do
  expect(page).to have_content 'Welcome bla@bla.net'
end


Given(/^an email has already been taken$/) do
	@user = User.create(email: "bla@bla.net", password: "42", password_confirmation: "42")
end

Then(/^I should be told the email has already been taken$/) do
	expect(page).to have_content "This email is already taken"
end

Given(/^I enter an email and non\-matching password$/) do
  fill_in 'register_email', with: "bla@bla.net"
  fill_in 'register_password', with: '12345678'
  fill_in 'register_password_confirmation', with: 'hello'
  click_button 'Sign Up'
end

Then(/^I should be told my passwords don't match$/) do
	expect(page).to have_content "Sorry, your passwords don't match"
end