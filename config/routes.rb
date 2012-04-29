P4dhack::Application.routes.draw do
  resources :posts, :except => [:edit, :update]

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }, :skip => [:sessions]
  devise_scope :user do
    match '/users/sign_out(.:format)', {:action=>"destroy", :controller=>"devise/sessions", :via => :delete, :as => :destroy_user_session }
    match '/users/login', {:action=>"login", :controller=>"users", :via => :get, :as => :new_user_session }
  end

  get '/users/current' => 'users#current', :as => :current_user
  get '/users/login' => 'users#login', :as => :login_user
  get '/users/:provider/:user_key' => 'users#show', :as => :user
  delete '/users/current' => 'users#destroy', :as => :destory_current_user

  get '/users/:user_id/posts/:year/:month/:day' => 'users::posts#day', :as => :user_day_posts, :year => /\d+/, :month => /\d+/, :day => /\d+/
  get '/users/:user_id/posts/:year/:month' => 'users::posts#month', :as => :user_month_posts, :year => /\d+/, :month => /\d+/
  get '/users/:user_id/posts/:year' => 'users::posts#year', :as => :user_year_posts, :year => /\d+/

  root :to => 'posts#new'
end
