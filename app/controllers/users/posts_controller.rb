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
  end
end
