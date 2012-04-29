require 'spec_helper'

describe Event do
  ancestors_should_include [ActiveRecord::Base]
  describe 'when call label' do
    subject { Event.find(id).label }
    (1..5).each do |id|
      context "id:#{id} should return localized string" do
        let(:id) { id }       
        it { should == I18n.t("event.records.#{id}") }
      end
    end
  end
end
