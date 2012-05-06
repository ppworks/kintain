require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.build(:user) }
  let(:new_user) { FactoryGirl.build(:new_user) }
  let(:auth) {
    {
      'uid' => '123456',
      'info' => {
        'name' => new_user.name,
        'nickname' => new_user.name,
        'image' => new_user.image,
        'email' => new_user.email,
      },
      'credentials' => {
        'token' => 'token',
        'secret' => 'secret'
      },
      'extra' => {
        'raw_info' => {
          'avatar_url' => new_user.image
        }
      }
    }
  }
  
  describe 'User instance' do
    it { user.should be_instance_of User }
  end
  describe 'facebook login' do
    it { User.find_for_facebook_oauth(auth, nil).should be_present }
  end
  describe 'twitter login' do
    it { User.find_for_twitter_oauth(auth, nil).should be_present }
  end
  describe 'github login' do
    it { User.find_for_github_oauth(auth, nil).should be_present }
  end
  describe 'mixi login' do
    it { User.find_for_mixi_oauth(auth, nil).should be_present }
  end
end
