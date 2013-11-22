Given(/^I am signed in$/) do
  @user = FactoryGirl.create(:user)
  visit new_user_session_path
  fill_in 'user_email', :with => @user.email
  fill_in('user_password', :with => @user.password)
  click_button('Sign in')
  current_path.should == '/'
  page.should have_content('Sign out')
end

When(/^I go to the Add Page page/) do
  click_link("Add page")
  current_path.should == edit_page_path
end

And(/^I create a page entitled "(.*?)" with content "(.*?)"$/) do |title, content|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see a new page entitled "(.*?)" with content "(.*?)"$/) do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end