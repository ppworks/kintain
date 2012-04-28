#=SocialSync
# SocialSync is the library to sync with data on social media service.
# all method call 'method_missing'
module SocialSync
  @@version = '0.0.1'
  
  @no_param_methods = {'facebook' => ['test_user', 'test_user!']}
  # library version
  def self.version
    @@version
  end
  
  # When call SocialSync::{method_name}
  # dispatch this method
  # 
  def self.method_missing method_name, user, params = {}
    if params[:provider_id].present?
      provider_id = params[:provider_id]
      provider = user.providers.where(:id => provider_id).first
    elsif user.present?
      provider = user.default_provider
    else
      raise self::NoProviderException, 'no provider specified.'
    end
    providers_user = user.providers_users.where(:provider_id => provider.id).first
    params[:providers_user] = providers_user
    begin
      m = const_get(provider.name.camelcase, false)
      # call the specific provider's method
      if @no_param_methods[provider.name].present? && @no_param_methods[provider.name].include?(method_name)
        m.send method_name
      else
        m.send method_name, providers_user.access_token, params
      end
    rescue NoMethodError => e
      e.backtrace.each { |line| Artist.logger.error line }
      raise self::NoMethodException, "invalid method('#{method_name}') specified. error_message: #{e.message}"
    rescue NameError => e
      raise self::NoProviderException, "invalid provider(id:'#{provider.id}') specified. error_message: #{e.message}"
    end
  end
  
end