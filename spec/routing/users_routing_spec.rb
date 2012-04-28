require "spec_helper"

describe UsersController do
  describe "routing" do

    it "routes to #current" do
      get("/users/current").should route_to("users#current")
    end
    
    it "routes to #show" do
      get("/users/facebook/12345").should route_to("users#show", :provider => 'facebook', :user_key => "12345")
    end
    
    it "routes to #destroy" do
      delete("/users/current").should route_to("users#destroy")
    end
    
    it "routes to #login" do
      get("/users/login").should route_to("users#login")
    end
  end
end
