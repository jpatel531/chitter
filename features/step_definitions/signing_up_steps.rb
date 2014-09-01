Given(/^that I am on the homepage$/) do
  visit '/'
end

Given(/^I enter an email and password$/) do
  fill_in 'email', with: "bla@bla.com"
  fill_in 'password', with: '12345678'
  fill_in 'password_confirmation', with: '12345678'
  click_button 'Sign Up'
end

Then(/^I should see a welcome message$/) do
  expect(page).to have_content 'Welcome bla@bla.com'
end