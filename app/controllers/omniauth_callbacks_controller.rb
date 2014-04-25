class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def twitter
    raise request.env["omniauth.auth"].to_yaml
  end

  def failure
    xxxxxxx
  end
end
