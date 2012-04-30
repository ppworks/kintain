class Users::PostsController < ApplicationController
  def day
    @date = Time.zone.parse "#{params[:year]}-#{params[:month]}-#{params[:day]}"
    @posts = Post.where(:user_id => @user.id)
    @posts = Post
      .where(:user_id => @user.id)
      .one_day(@date)
      .all 
    @prev = @date - 1.day
    @next = @date + 1.day
  end 

  def month
    @date = Time.zone.parse "#{params[:year]}-#{params[:month]}-01"
    
    posts = Post.where(:user_id => @user.id)
    posts = Post
      .where(:user_id => @user.id)
      .one_month(@date)
      .all
    @posts = Post.convert_monthly_chart @date, posts 
    @prev = @date - 1.month
    @next = @date + 1.month
  end
end
