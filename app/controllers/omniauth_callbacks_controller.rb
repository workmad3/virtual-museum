class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def twitter
    user = User.process_omniauth(request.env["omniauth.auth"])
    if user.persisted?
      sign_in user
      flash[:notice] = 'Signed in successfully with Twitter'
      redirect_to root_path, status: 301
    else
      session["devise.user_attributes"] =
          user.attributes
      redirect_to new_user_registration_url
    end
  end

end
