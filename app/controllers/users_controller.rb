class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:login, :show]
  
  def current
    @user = User.find current_user.id
  end
  
  def show
    begin
      @user = User.find_by_path params[:provider], params[:user_key]
    rescue => e
      logger.error e.message
      return head :not_found
    end
  end
  
  def destroy
    user = User.find current_user.id
    user.destroy
    redirect_to root_path, :notice => t('users.current.withdraw.completed')
  end
  
  def login
    
  end
end
