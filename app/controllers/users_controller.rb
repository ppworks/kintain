class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:login, :show]
  
  def current
    @user = User.find current_user.id
    @day = Time.current
    @posts = Post
      .where(:user_id => @user.id)
      .one_day(@day)
      .all 
    @prev = @day - 1.day
    @next = @day + 1.day
  end
  
  def show
    begin
      @user = User.find_by_path params[:provider], params[:user_key]
      @day = Time.current 
      posts = Post
        .where(:user_id => @user.id)
        .one_month(@day)
        .all

      @posts = Post.convert_monthly_chart @day, posts 
      @prev = @day - 1.month
      @next = @day + 1.month
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
