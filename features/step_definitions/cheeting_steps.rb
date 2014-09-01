require 'launchy'

When(/^I enter a cheet and press submit$/) do
  fill_in 'cheet', with: 'Hello World'
  click_button 'Post!'
end

Then(/^I should see the cheet on the page$/) do
	sleep 10
	expect(page).to have_content 'Hello World'
end