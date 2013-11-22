Given(/^I am signed in$/) do
  @user = FactoryGirl.create(:user)
  visit new_user_session_path
  fill_in 'user_email', :with => @user.email
  fill_in('user_password', :with => @user.password)
  click_button('Sign in')
  visit edit_user_registration_path
  page.should have_content('Sign out')
end

When(/^I go to the Add Page page/) do
  pending # express the regexp above with the code you wish you had
end

And(/^I add a page entitled "(.*?) with content (.*?)"$/) do |title, content|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see  a page entitled "(.*?) with content (.*?)"$/) do |title, content|
  pending # express the regexp above with the code you wish you had
end