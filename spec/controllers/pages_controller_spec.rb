require 'spec_helper'

describe PagesController do

  describe "GET 'terms'" do
    it "returns http success" do
      get 'terms'
      response.should be_success
    end
  end

  describe "GET 'policy'" do
    it "returns http success" do
      get 'policy'
      response.should be_success
    end
  end

end
