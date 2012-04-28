module SocialSync
  #
  # When facebook return Feed action request limit reached.
  #
  class RequestLimitException < Exception
  end
end