require 'spec_helper'
describe ApplicationHelper do
  describe 'fb_connect_js' do
    context 'locale is not specified' do
      it { helper.fb_connect_js.should === '//connect.facebook.net/en_US/all.js' }
    end
    context 'locale is en' do
      before do
        I18n.locale = :en
      end
      it { helper.fb_connect_js.should === '//connect.facebook.net/en_US/all.js' }
    end
    context 'locale is ja' do
      before do
        I18n.locale = :ja
      end
      it { helper.fb_connect_js.should === '//connect.facebook.net/ja_JP/all.js' }
    end
  end
end
