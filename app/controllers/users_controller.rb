class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:login, :show]
  
  def current
    @user = User.find current_user.id
    @day = Time.current
    @posts = Post.where(:user_id => @user.id)
    @posts = @posts.where("created_at >= '#{@day.beginning_of_day.strftime("%Y-%m-%d %H:%M:%S")}' AND created_at <= '#{@day.end_of_day.strftime("%Y-%m-%d %H:%M:%S")}'")
    @posts = @posts.order("created_at ASC").all
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
