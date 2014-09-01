
Given(/^I click "(.*?)"$/) do |arg1|
	click_button arg1
end

Then(/^I should be invited to log back in$/) do
	expect(page).to have_content 'Log In!'
end