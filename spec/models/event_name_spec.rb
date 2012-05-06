require 'spec_helper'

describe EventName do
  before do
    I18n.locale = :en
  end
  ancestors_should_include [ActiveRecord::Base]
  describe 'self.list method' do
    let(:user) { FactoryGirl.create :user }
    context 'user has no event_names' do
      it {
        EventName.list(user).each do|event_name|
          event_name.should be_new_record
        end
      }
    end
    context 'user has custom event_names' do
      before do
        user.event_names << EventName.new(:event_id => 1, :name => 'test')
      end
      it {
        EventName.list(user)[0,1].each do|event_name|
          event_name.should_not be_new_record
        end
      }
      it {
        EventName.list(user)[2,4].each do|event_name|
          event_name.should be_new_record
        end
      }
    end 
  end
  describe 'self.list method' do
    let(:user) { FactoryGirl.create :user }
    let(:hash) { hash = {};Event.all.each{|e|hash[e.id.to_s] = e.label};hash }
    context 'user has no event_names' do
      context 'passed no changed parameter' do
        subject { EventName.update_by_hash(hash, user) }
        its([0]) { should be_new_record }
        its([1]) { should be_new_record }
        its([2]) { should be_new_record }
        its([3]) { should be_new_record }
        its([3]) { should be_new_record }
      end
    end
    context 'user has new event_names' do
      context 'passed changed parameter' do
        before do
          hash['1'] = 'new one'
        end
        subject { EventName.update_by_hash(hash, user) }
        its([0]) { should be_persisted }
        its([1]) { should be_new_record }
        its([2]) { should be_new_record }
        its([3]) { should be_new_record }
        its([4]) { should be_new_record }
      end
    end
    context 'user has invalid new event_names' do
      context 'passed changed parameter' do
        before do
          hash['1'] = 'toooooooooooooo long name'
        end
        subject { EventName.update_by_hash(hash, user)[0] }
        its('errors') { subject[:name][0].should match /is too long/ }
      end
    end
  end
end
