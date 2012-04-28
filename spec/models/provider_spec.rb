require 'spec_helper'

describe Provider do
  it 'provider has 3 providers' do
    Provider.all.count.should == 3
  end
  
  describe 'providers' do
    it { Provider.facebook.should be_present }
    it { Provider.twitter.should be_present }
    it { Provider.github.should be_present }
  end
end
