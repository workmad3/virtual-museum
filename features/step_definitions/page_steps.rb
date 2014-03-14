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
  click_link('Add page')
  current_path.should == new_page_path

  fill_in('title', :with => title)
  fill_in('content', :with => content)
  click_button('Create')
end

Then(/^I can see a page entitled "(.*?)" with content "(.*?)"$/) do |title, content|
  current_slug = current_path.sub /.*\//, ''
  current_path.should == pages_path + '/' + current_slug

  page.should have_content(title)
  page.should have_content(content)
end

When(/^I change the content to "(.*?)"$/) do |new_content|
  click_link('Edit')
  fill_in('content', with: new_content)
  click_button 'Save'
  # PageState.count.should == 1 # TODO eliminate bad practice db in feature steps file
end

When(/^I change the title to "(.*?)"$/) do |new_title|
  click_link('Edit')
  fill_in('title', with: new_title)
  click_button 'Save'
  # PageState.count.should == 1  # TODO eliminate bad practice db in feature steps file

end



