module SocialSync
  # SocialSync library sync with Twitter account.
  class Twitter
    # fetch friends uid array
    def self.friends token, params = {}
      self.configure_twitter token, params[:providers_user].secret
      friend_ids = ::Twitter.follower_ids(params[:providers_user].name)['ids']
      # FIXME: move to profiles mathod
      results = []
      friend_divided_ids = friend_ids.divide 100
      friend_divided_ids.each do |friend_ids|
        params[:uid] = friend_ids
        res = self.profiles token, params
        if res.present?
          results = results + res
        end
      end
      results
    end
    
    def self.profiles token, params = {}
      friend_ids = params[:uid]
      self.configure_twitter token, params[:providers_user].secret
      results = []
      friends = ::Twitter.users(*friend_ids)
      if friends.present?
        friends.select! do |user|
          user['following']
        end
        friends.each do |user|
          results << self.format_profile(user)
        end
      end
      results
    end
    
    def self.post token, params
      post_key = params[:post_key]||raise(ArgumentError, 'luck of params[:post_key]')
      self.configure_twitter token, params[:providers_user].secret
      res = ::Twitter.status(post_key)
    end
    
    # not support
    def self.stream token, params = {}
      return {}
    end
    
    # post
    def self.post! token, params
      self.configure_twitter token, params[:providers_user].secret
      res = ::Twitter.update(params[:message])
      res.instance_eval <<-EVAL
        def identifier
          "#{res['id']}"
        end
      EVAL
      res
    end
    
    def self.message! token, params
      self.configure_twitter token, params[:providers_user].secret
      res = ::Twitter.direct_message_create(params[:target_id], params[:message])
    end
    
    # comment to post
    def self.comment! token, params
      post_key = params[:post_key]||raise(ArgumentError, 'luck of params[:post_key]')
      post = self.post token, params
      screen_name = post['user']['screen_name']
      res = ::Twitter.update("@#{screen_name} #{params[:message]}", {:in_reply_to_status_id => params[:post_key]})
      res.instance_eval <<-EVAL
        def identifier
          "#{res['id']}"
        end
      EVAL
      res
    end
    
    # like to post
    # Twitter::Forbidden (POST https://api.twitter.com/1/favorites/create/117962119365922817.json: 403: You have already favorited this status.):
    def self.like! token, params
      post_key = params[:post_key]||raise(ArgumentError, 'luck of params[:post_key]')
      self.configure_twitter token, params[:providers_user].secret
      res = ::Twitter.favorite_create params[:post_key]
      res.present?
    end
    
    # cancel like to post
    def self.unlike! token, params
      post_key = params[:post_key]||raise(ArgumentError, 'luck of params[:post_key]')
      self.configure_twitter token, params[:providers_user].secret
      res = ::Twitter.favorite_destroy params[:post_key]
      res.present?
    end
    
    protected
    def self.configure_twitter token, secret
      ::Twitter.configure do |config|
        config.consumer_key = TwitterConfig.app_id
        config.consumer_secret = TwitterConfig.app_secret
        config.oauth_token = token
        config.oauth_token_secret = secret
      end
    end
    
    def self.format_profile user
      {
        :id => user['id'].to_s,
        :name => user['name'],
        :screen_name => user['screen_name'],
        :pic_square => user['profile_image_url'],
        :url => "http://twitter.com/#!/#{user['screen_name']}",
        :provider => :twitter
      }
    end
  end
end
class Array
  def divide num
    start = 0
    result = []
    while self.size > start
      result << self.slice(start, num)
      start+=num
    end
    result
  end
end