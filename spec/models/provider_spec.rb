require 'spec_helper'

describe Provider do
  it 'provider has 4 providers' do
    Provider.all.count.should == 4
  end
  
  describe 'providers' do
    it { Provider.facebook.should be_present }
    it { Provider.twitter.should be_present }
    it { Provider.github.should be_present }
    it { Provider.mixi.should be_present }
  end
end
