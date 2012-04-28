class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_facebook_oauth(env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      flash[:notice] = I18n.t "devise.omniauth_callbacks.failure", :kind => "Facebook", :reason => "User create error"
      redirect_to root_path
    end
  end

  def twitter
    @user = User.find_for_twitter_oauth(env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
      sign_in_and_redirect @user, :event => :authentication
    else
      flash[:notice] = I18n.t "devise.omniauth_callbacks.failure", :kind => "Twitter", :reason => "User create error"
      redirect_to root_path
    end
  end
  
  def github
    @user = User.find_for_github_oauth(env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Github"
      sign_in_and_redirect @user, :event => :authentication
    else
      flash[:notice] = I18n.t "devise.omniauth_callbacks.failure", :kind => "Github", :reason => "User create error"
      redirect_to root_path
    end
  end

  def mixi
    @user = User.find_for_mixi_oauth(env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "mixi"
      sign_in_and_redirect @user, :event => :authentication
    else
      flash[:notice] = I18n.t "devise.omniauth_callbacks.failure", :kind => "mixi", :reason => "User create error"
      redirect_to root_path
    end
  end
end
