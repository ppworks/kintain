module MixiConfig
  def self.app_id
    ENV["MIXI_APP_ID"]
  end

  def self.app_secret
    ENV["MIXI_APP_SECRET"]
  end
  
  def self.scope
    ENV["MIXI_SCOPE"]||'r_profile w_voice'
  end
end
