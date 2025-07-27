class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :google_oauth2
  skip_before_action :authenticate_user!

  def google_oauth2
    callback_for(:google)
  end

  def callback_for(provider)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.to_s.capitalize) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url
    end
  end


  def failure
    redirect_to root_path, alert: "認証に失敗しました。"
  end
end
