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