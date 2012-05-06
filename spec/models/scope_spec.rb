require 'spec_helper'

describe Scope do
  ancestors_should_include [ActiveRecord::Base]
  it 'scopes has 2 scopes' do
    Scope.all.count.should == 2
  end
end
