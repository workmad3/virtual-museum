Given(/^I am signed in$/) do
  @user = FactoryGirl. build(:user)

  visit '/users/sign_up' # new_user_session_path
  fill_in 'user_email', :with => @user.email
  fill_in('user_password', :with => @user.password)
  fill_in('user_password_confirmation', :with => @user.password)
  click_button('sign_up_button')

  current_path.should == '/'
  page.should have_content('Logout')
end

When(/^I create a page entitled "(.*?)" with content "(.*?)"$/) do |title, content|
  click_link('add_page_link')
  current_path.should == new_page_path

  fill_in('Title', :with => title)
  fill_in('Content', :with => content)
  click_button('Create Page')
end

Then(/^I can see a page entitled "(.*?)" with content "(.*?)"$/) do |title, content|
  current_slug = current_path.sub /.*\//, ''
  current_path.should == pages_path + '/' + current_slug

  page.should have_content(title)
  page.should have_content(content)
end

When(/^I create a tagged page entitled "(.*?)" with content "(.*?)" and tags (.*?)$/) do |title, content, tags|
  click_link('add_page_link')
  current_path.should == new_page_path

  fill_in('Title',   :with => title)
  fill_in('Content', :with => content)
  fill_in('Tags',    :with => tags)

  click_button('Create Page')end

Then(/^I can see a tagged page entitled "(.*?)" with content "(.*?)" and tags "(.*?)"$/) do |title, content, tags|
  current_slug = current_path.sub /.*\//, ''
  current_path.should == pages_path + '/' + current_slug

  page.should have_content(title)
  page.should have_content(content)
  page.should have_content(tags)

end






