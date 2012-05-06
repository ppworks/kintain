class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:login, :show]
  
  def current
    @user = User.find current_user.id
    @date = Time.current
    @posts = Post
      .where(:user_id => @user.id)
      .one_day(@date)
      .all 
    @prev = @date - 1.day
    @next = @date + 1.day
  end
  
  def show
    begin
      @user = User.find_by_path params[:provider], params[:user_key]
      @date = Time.current 
      posts = Post
        .where(:user_id => @user.id)
        .one_month(@date)
        .all

      @posts = Post.convert_monthly_chart @date, posts 
      @prev = @date - 1.month
      @next = @date + 1.month
    rescue => e
      logger.error e.message
      return head :not_found
    end
  end

  def edit
    @user = User.find current_user.id
  end

  def update
    user = User.find current_user.id
    user.scope_id = params[:scope_id]
    user.save
    redirect_to current_user_path, :notice => t('users.current.edited')
  end
  
  def destroy
    user = User.find current_user.id
    user.destroy
    redirect_to root_path, :notice => t('users.current.withdraw.completed')
  end
  
  def login
    
  end
end
