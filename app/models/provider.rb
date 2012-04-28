class Provider < ActiveRecord::Base
  has_many :users, :through => :providers_users
  
  # FIXME: class_eval & define_method
  def self.facebook
    self.find_by_provider_name 'facebook'
  end
  
  def self.twitter
    self.find_by_provider_name 'twitter'
  end
  
  def self.github
    self.find_by_provider_name 'github'
  end

  def self.mixi
    self.find_by_provider_name 'mixi'
  end
  
  private
  def self.find_by_provider_name provider_name
    Rails.cache.fetch("model_provider_#{provider_name}", :expires_in => 365.days) do
      select(:id).find_by_name(provider_name)
    end
  end
end
