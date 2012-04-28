module FacebookConfig
  def self.admins
    ENV["FB_ADMINS"]
  end
  def self.app_id
    ENV["FB_APP_ID"]
  end

  def self.app_secret
    ENV["FB_APP_SECRET"]
  end
  
  def self.scope
    ENV["FB_SCOPE"]||'email'
  end
end