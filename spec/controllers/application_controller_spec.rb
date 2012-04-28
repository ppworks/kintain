require 'spec_helper'

describe ApplicationController do

  describe "set_locale" do
    it "should be ja" do
      request.env['HTTP_ACCEPT_LANGUAGE'] = "ja,en-US;q=0.8,en;q=0.6"
      controller.instance_eval{set_locale}
      I18n.locale.should == :ja
    end
    
    it "should be en" do
      request.env['HTTP_ACCEPT_LANGUAGE'] = "en-US,en;q=0.8,en;q=0.6"
      controller.instance_eval{set_locale}
      I18n.locale.should == :en
    end
  end
end
