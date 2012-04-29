class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:login, :show]
  
  def current
    @user = User.find current_user.id
    @day = Time.current
    @posts = Post.where(:user_id => @user.id)
    @posts = @posts.where("created_at >= ?", @day.beginning_of_day)
    @posts = @posts.where("created_at <= ?", @day.end_of_day)
    @posts = @posts.order("created_at ASC").all
    @prev = @day - 1.day
    @next = @day + 1.day
  end
  
  def show
    begin
      @user = User.find_by_path params[:provider], params[:user_key]
      @day = Time.current 
      
      posts = Post.where(:user_id => @user.id)
      posts = posts.where("created_at >= ?", @day.beginning_of_day)
      posts = posts.where("created_at <= ?", @day.end_of_day)
      posts = posts.order("created_at DESC").all

      @posts = [nil] 
      1.upto(@day.end_of_month.day) do |day|
        @posts[day] = []
      end
      posts.each do|post|
        day = post.created_at.strftime('%d')
        @posts[day.to_i] << post if post.official?
      end
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
