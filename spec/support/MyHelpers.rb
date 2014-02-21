module UserAndPageHelpers
  def user
    @user || @user = FactoryGirl.create(:user)
  end
  def page
    @page || @page = FactoryGirl.create(:page, user: user)
  end
  def user2
    @user2 || @user2 = FactoryGirl.create(:user)
  end
  def page2
    @page2 || @page2 = FactoryGirl.create(:page, user: user2)
  end
  def page_state
    @previous_page || @previous_page = FactoryGirl.create(:page_state, page: page, user: user)
  end
end