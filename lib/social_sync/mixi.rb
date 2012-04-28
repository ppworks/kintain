module SocialSync
  # SocialSync library sync with Mixi account.
  class Mixi
    # fetch friends uid array
    def self.friends token, params = {}
      response = self.fetch_mixi params[:providers_user] do |token_obj|
        response = JSON.parse token_obj.get('/2/people/@me/@friends?count=1000')
        response = response["entry"]
        response.map do|user|
          self.format_profile user
        end
      end
    end
    
    def self.profiles token, params = {}
      if params[:uid].present?
        uid_condition = 'id IN (' + params[:uid].join(',') + ')'
      else
        uid_condition = 'id = me()'
      end

      res = self.exec_fql <<-FQL, token
        SELECT
          id, name, url, pic, pic_square, pic_small,
          pic_big, type, username
        FROM profile WHERE #{uid_condition}
      FQL
      
      res.map do |user|
        self.format_profile user
      end
    end
    
    # fetch 1 post only
    def self.stream token, params = {}
      return [] if params[:post_key].blank?
      post_key = params[:post_key]
      user_key = params[:providers_user].user_key
      comments = self.fetch_posts_comments params[:providers_user], post_key
      likes = self.fetch_posts_likes params[:providers_user], post_key
      res = [{
        :comments => comments,
        :likes => likes
      }]
      provider_profiles = {}
      streams = []
      comment_like_ids = {}
      res.each do |stream|
        comments = []
        stream[:comments].each do |comment|
          comments << {
            :provider_id => Provider.mixi.id,
            :post_key => comment['id'].to_s,
            :user_key => comment['user']['id'].to_s,
            :content => comment['text'],
            :created_at => Time.parse(comment['created_at']),
            :like_count => 0,
            :user_likes => []
          }
          provider_profiles[comment['user']['id'].to_s] = {
            :provider_id => Provider.mixi.id,
            :user_key => comment['user']['id'].to_s,
            :name => comment['user']['screen_name'].to_s,
            :pic_square => comment['user']['profile_image_url'],
            :url => comment['user']['url']
          }
          comment_like_ids[comment['id'].to_s] = {:like_count => 0}
        end
        likes = []
        stream[:likes].each do |like|
          likes << {
            :provider_id => Provider.mixi.id,
            :post_key => nil,
            :user_key => like['id'].to_s
          }
          provider_profiles[like['id'].to_s] = {
            :provider_id => Provider.mixi.id,
            :user_key => like['id'].to_s,
            :name => like['screen_name'].to_s,
            :pic_square => like['profile_image_url'],
            :url => like['url']
          }
        end
        streams << {
          :provider_id => Provider.mixi.id,
          :post_key => post_key,
          :user_key => user_key,
          :content => '', # not to need property for Post#sync!
          :created_at => '', # not to need property for Post#sync!
          :comments => comments,
          :likes => likes,
          :user_likes => false # mixi not allow like to own post
        }
      end
      {:streams => streams, :comment_likes => [], :provider_profiles => provider_profiles}
    end
    
    # post
    def self.post! token, params
      response = self.fetch_mixi params[:providers_user] do |token_obj|
        response = token_obj.post('/2/voice/statuses', {:status => params[:message]})
      end
      response = JSON.parse response
      response.instance_eval <<-EVAL
        def identifier
          "#{response['id']}"
        end
      EVAL
      response
    end
    
    def self.message! token, params
      response = self.fetch_mixi params[:providers_user] do |token_obj|
        result = nil
        params[:providers_user].reload
        token = params[:providers_user].access_token
        http = Net::HTTP.new('api.mixi-platform.com',80)
        http.start{
          headers = {'Authorization' => "OAuth #{token}",
                      'HOST' => 'api.mixi-platform.com', 
                      'Content-Type' => "application/json"}
          query_json = {
            'title' => params[:title],
            'body' => params[:message],
            'recipients' => params[:target_id]
          }.to_json
          body = http.post("/2/messages/@me/@self/@outbox", query_json, headers).body
          result = JSON.parse(body)
        }
        result
      end
    end
    
    # comment to post
    def self.comment! token, params
      post_key = params[:post_key]||raise(ArgumentError, 'luck of params[:post_key]')
      response = self.fetch_mixi params[:providers_user] do |token_obj|
        response = token_obj.post("/2/voice/replies/create/#{post_key}", {:text => params[:message]})
      end
      response = JSON.parse response
      Artist.logger.info response
      response.instance_eval <<-EVAL
        def identifier
          "#{response['id']}"
        end
      EVAL
      response
    end
    
    # like to post
    def self.like! token, params

      post_key = params[:post_key]||raise(ArgumentError, 'luck of params[:post_key]')
      response = self.fetch_mixi params[:providers_user] do |token_obj|
        response = token_obj.post("/2/voice/favorites/create/#{post_key}")
      end
      response = JSON.parse response
      Artist.logger.info response
      response.present?
    end
    
    # cancel like to post
    def self.unlike! token, params
      post_key = params[:post_key]||raise(ArgumentError, 'luck of params[:post_key]')
      response = self.fetch_mixi params[:providers_user] do |token_obj|
        response = token_obj.post("/2/voice/favorites/destroy/#{post_key}/#{params[:providers_user].user_key}")
      end
      response = JSON.parse response
      response.present?
    end
    
    protected
    def self.fetch_mixi providers_user
      client = OAuth2::Client.new(
        MixiConfig.app_id,
        MixiConfig.app_secret,
        :site => 'http://api.mixi-platform.com',
        :authorize_url => 'https://mixi.jp/connect_authorize.pl',
        :access_token_url => 'https://secure.mixi-platform.com/2/token'
      )
      retry_count = 0
      begin
        access_token = providers_user.access_token
        token = OAuth2::AccessToken.new(client, access_token)
        res = yield token
      rescue => e
        token = client.web_server.refresh_access_token(providers_user.refresh_token, :grant_type => "refresh_token")
        
        providers_user.access_token = token.token
        providers_user.refresh_token = token.refresh_token
        providers_user.save!
        retry_count += 1
        retry if retry_count == 1
        raise e
      end
    end
    
    def self.format_profile user
      {
        :id => user['id'].to_s,
        :name => user['displayName'],
        :pic_square => user['thumbnailUrl'],
        :url => user['profileUrl'],
        :provider => :mixi
      }
    end
    
    def self.fetch_posts_comments providers_user, post_key
      response = self.fetch_mixi providers_user do |token_obj|
        response = JSON.parse token_obj.get("/2/voice/replies/show/#{post_key}");
      end
    end
    
    def self.fetch_posts_likes providers_user, post_key
      response = self.fetch_mixi providers_user do |token_obj|
        response = JSON.parse token_obj.get("/2/voice/favorites/show/#{post_key}");
      end
    end
  end
end