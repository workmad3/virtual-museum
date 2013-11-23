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
  current_path.should == new_page_path
end

And(/^I create a page entitled "(.*?)" with content "(.*?)"$/) do |title, content|
  fill_in('title', :with => title)
  fill_in('content', :with => content)
  click_button('Create')
end

Then(/^I can see a page entitled "(.*?)" with content "(.*?)"$/) do |title, content|
  visit '/'
  page.should have_link(title)
  click_link(title)
  current_slug = current_path.sub /.*\//,''
  current_path.should == pages_path + '/' + current_slug
  page.should have_content(title)
  page.should have_content(content)
end

When(/^I change the content to "(.*?)"$/) do |arg1|
  click_link("Edit")
end
