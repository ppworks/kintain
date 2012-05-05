class PostsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]

  # GET /posts/1
  # GET /posts/1.json
  def show
    post = Post.find(params[:id])
    day = post.created_at
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
        url = Rails.application.routes.url_helpers.post_url(@post.id, :host => request.host)
        opts = {
          :message => @post.label + " #{url} #{ENV['HASH_TAG']}"
        }
        begin
          SocialSync.post!(current_user, opts.merge({:provider_id => Provider.facebook.id})) if params[:facebook].present?
          SocialSync.post!(current_user, opts.merge({:provider_id => Provider.twitter.id})) if params[:twitter].present?
          SocialSync.post!(current_user, opts.merge({:provider_id => Provider.mixi.id})) if params[:mixi].present?
        rescue => e
          logger.error e
        ensure
          format.html { redirect_to current_user_path }
          format.json { render json: @post, status: :created, location: @post }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
end
