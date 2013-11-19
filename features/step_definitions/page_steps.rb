Given(/^I am signed in$/) do
  @user = FactoryGirl.create(:user)
  visit new_user_session_path
  fill_in 'user_email', :with => @user.email
  fill_in('user_password', :with => @user.password)
  click_button('Sign in')
  visit edit_user_registration_path
  page.should have_content(@user.email)
end

When(/^I add a page entitled "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see the page "(.*?)" on the home page$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end