module TwitterConfig
  def self.app_id
    ENV["TW_APP_ID"]
  end

  def self.app_secret
    ENV["TW_APP_SECRET"]
  end
end