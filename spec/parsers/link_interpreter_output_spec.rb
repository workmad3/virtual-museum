require 'spec_helper'
require './lib/parsing/link_interpreter'

describe LinkInterpreter do
  it "should process a hyperlink to an existing page" do
    @user = FactoryGirl.create(:user)
    @page = FactoryGirl.create(:page)
    @page_state = FactoryGirl.create(:page_state, title: @page.original_title, user: @user, page: @page)
    li=LinkInterpreter.new(@page.title)

  end
  it "should process a hyperlink to a missing page" do
    false
  end

end