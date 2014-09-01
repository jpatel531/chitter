Given(/^that I am on the homepage$/) do
  visit '/'
end

Given(/^I enter an email and password$/) do
  fill_in 'Email', with: "bla@bla.com"
  fill_in 'Password', with: '12345678'
end

Then(/^I should see a welcome message$/) do
  expect(page).to have_content 'Welcome bla@bla.com'
end