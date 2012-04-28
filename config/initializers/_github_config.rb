module GithubConfig
  def self.app_id
    ENV["GH_APP_ID"]
  end

  def self.app_secret
    ENV["GH_APP_SECRET"]
  end
  
  def self.scope
    ENV["GH_SCOPE"]||''
  end
end