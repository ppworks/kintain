class Users::PostsController < ApplicationController
  def day
    @day = Time.parse "#{params[:year]}-#{params[:month]}-#{params[:day]}"
    @posts = Post.where(:user_id => @user.id)
    @posts = @posts.where("created_at >= '#{@day.beginning_of_day.strftime("%Y-%m-%d %H:%M:%S")}' AND created_at <= '#{@day.end_of_day.strftime("%Y-%m-%d %H:%M:%S")}'")
    @posts = @posts.order("created_at ASC").all
  end 

  def month
    @day = Time.parse "#{params[:year]}-#{params[:month]}-01"
    
    posts = Post.where(:user_id => @user.id)
    posts = posts.where("created_at >= '#{@day.beginning_of_month.strftime("%Y-%m-%d %H:%M:%S")}' AND created_at <= '#{@day.end_of_month.strftime("%Y-%m-%d %H:%M:%S")}'")
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
  end

  def year
    
  end
end
