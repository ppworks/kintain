class PostsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]

  # GET /posts/1
  # GET /posts/1.json
  def show
    day = Time.current
    post = Post.find(params[:id])
    redirect_to user_day_posts_path(:user_id => post.user_id, :year => day.year, :month => day.month, :day => day.day)
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new
    @events = Event.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        opts = {
          :message => @post.event.label + " http://kintain.herokuapp.com #kintain"
        }
        SocialSync.post!(current_user, opts.merge({:provider_id => Provider.facebook.id})) if params[:facebook].present?
        SocialSync.post!(current_user, opts.merge({:provider_id => Provider.twitter.id})) if params[:twitter].present?
        format.html { redirect_to current_user_path }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
end
