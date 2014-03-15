Then(/^I can see a hyperlink to a "(.*?)" page$/) do |arg1|
  within(:xpath, "id('content_tab')/p/a") do
    page.should have_content(arg1)
  end
end

Then(/^I can see a rendition of an image$/) do
  within(:xpath, "id('content_tab')/div/img") do
    page.should have_content('')
  end
end

Then(/^I can see a You Tube video$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I can see a Vimeo video$/) do
  pending # express the regexp above with the code you wish you had
end

