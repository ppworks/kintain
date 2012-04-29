class Users::PostsController < ApplicationController
  def day
    @day = Time.parse "#{params[:year]}-#{params[:month]}-#{params[:day]}"
    @posts = Post.where(:user_id => @user.id)
    @posts = @posts.where("created_at >= '#{@day.beginning_of_day.strftime("%Y-%m-%d %H:%M:%S")}' AND created_at <= '#{@day.end_of_day.strftime("%Y-%m-%d %H:%M:%S")}'")
    @posts = @posts.order("created_at DESC").all
  end 

  def month
  end

  def year
  end
end