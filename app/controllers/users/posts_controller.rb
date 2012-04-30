class Users::PostsController < ApplicationController
  def day
    @day = Time.zone.parse "#{params[:year]}-#{params[:month]}-#{params[:day]}"
    @posts = Post.where(:user_id => @user.id)
    @posts = Post
      .where(:user_id => @user.id)
      .one_day(@day)
      .all 
    @prev = @day - 1.day
    @next = @day + 1.day
  end 

  def month
    @day = Time.zone.parse "#{params[:year]}-#{params[:month]}-01"
    
    posts = Post.where(:user_id => @user.id)
    posts = Post
      .where(:user_id => @user.id)
      .one_month(@day)
      .all
    @posts = Post.convert_monthly_chart @day, posts 
    @prev = @day - 1.month
    @next = @day + 1.month
  end
end
