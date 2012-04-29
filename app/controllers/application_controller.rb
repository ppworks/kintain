class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale, :set_user

  protected
  def set_locale
    I18n.locale = extract_locale_from_accept_language_header
  end
  
  def set_user
    @user = User.find params[:user_id] if params[:user_id].present?
  end
  private
  def extract_locale_from_accept_language_header
    http_accept_language = request.env['HTTP_ACCEPT_LANGUAGE']
    if http_accept_language.present?
      http_accept_language.scan(/^[a-z]{2}/).first
    else
      :en
    end
  end
end
