require 'launchy'

When(/^I enter a cheet and press submit$/) do
  fill_in 'cheet', with: "Hello World"
  find('.post-cheet').trigger(:click)
end

Then(/^I should see the cheet on the page$/) do
	sleep 5
	expect(page).to have_content 'Hello World'
end

When(/^I post an oversized cheet$/) do
	fill_in 'cheet', with: "WHETHER I shall turn out to be the hero of my own life, or whether that station will be held by anybody else, these pages must show. To begin my life with the beginning of my life, I record that I was born (as I have been informed and believe) on a Friday, at twelve o’clock at night. It was remarked that the clock began to strike, and I began to cry, simultaneously. In consideration of the day and hour of my birth, it was declared by the day and by some sage women in the neighbourhood who had taken a lively interest in me several months before there was any possibility of our becoming personally acquainted, first, that I was destined to be unlucky in life; and secondly, that I was privileged to see ghosts and spirits; both these gifts inevitably attaching, as they believed, to all unlucky infants of either gender born towards the small hours on a Friday night. I need say nothing here, on the first head, because nothing can show better than my history whether that prediction was verifed or falsified by the result. On the second branch of the question, I will only remark that unless I ran through that part of my inheritance while I was still a baby, I have not come into it yet. But I do not at all complain of having been kept out of this property; and if anybody else should be in the present enjoyment of it, he is heartily welcome to keep it.\n"

end

Then(/^I should be told off$/) do
	expect(page).to have_content "You're over 140 characters, bro."
end
