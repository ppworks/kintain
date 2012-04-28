module SocialSync
  # SocialSync library sync with Facebook account.
  class Facebook
    
    # fetch profile data list
    # 
    #=== params[:uid]
    #* String(but Numeric) Array : facebook user id if you want specific user's profile.
    #* nil : fetch my own profile.
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
    
    # fetch friends uid array
    def self.friends token, params = {}
      res = self.exec_fql <<-FQL, token
        SELECT uid2 FROM friend WHERE uid1 = me()
      FQL
      res.map!{|r|r['uid2'].to_s}
    end
    
    # fetch installed friends uid array
    def self.installed_friends token, params = {}
      res = self.exec_fql <<-FQL, token
        SELECT uid FROM user WHERE has_added_app=#{FacebookConfig.app_id} AND uid IN (SELECT uid2 FROM friend WHERE uid1 = me())
      FQL
      if res.present?
        res.map!{|user|user[:uid].to_s}
      else
        []
      end
    end
    
    # fetch stream which my posts and my friend posts
    def self.stream token, params = {}
      if params[:post_key].present?
        if params[:post_key].instance_of? Array
          post_condition = "AND post_id IN('" + params[:post_key].join("','") + "')"
        else
          post_condition = "AND post_id = '" + params[:post_key].to_s + "'"
        end
      else
        post_condition = ''
      end
      res = self.exec_fql <<-FQL, token
        SELECT post_id, viewer_id, app_id, source_id, updated_time, created_time, filter_key,
         attribution, actor_id, target_id, message, app_data, action_links, attachment,
         comments, likes, privacy, permalink, xid, tagged_ids
        FROM stream
        WHERE source_id IN (
          SELECT uid FROM user 
          WHERE has_added_app=#{FacebookConfig.app_id} 
          AND (
           uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) 
           OR uid = me()
          )
        )
        AND app_id = '#{FacebookConfig.app_id}'
        #{post_condition}
      FQL
      
      streams = []
      comment_like_ids = {}
      res.each do |stream|
        comments = []
        
        stream[:comments][:comment_list].each do |comment|
          comments << {
            :provider_id => Provider.facebook.id,
            :post_key => comment[:id].to_s,
            :user_key => comment[:fromid].to_s,
            :content => comment[:text],
            :created_at => Time.at(comment[:time]),
            :like_count => comment[:likes],
            :user_likes => comment[:user_likes]
          }
          comment_like_ids[comment[:id]] = {:like_count => comment[:likes]}
        end
        likes = []
        if stream[:likes][:user_likes]
          # viewer liked
          likes << {
            :provider_id => Provider.facebook.id,
            :post_key => nil,
            :user_key => stream[:viewer_id].to_s
          }
        end
        stream[:likes][:friends].each do |friend_id|
          # viewer friends liked
          likes << {
            :provider_id => Provider.facebook.id,
            :post_key => nil,
            :user_key => friend_id.to_s
          }
        end
        streams << {
          :provider_id => Provider.facebook.id,
          :post_key => stream[:post_id].to_s,
          :user_key => stream[:source_id].to_s,
          :content => stream[:message],
          :created_at => Time.at(stream[:created_time]),
          :comments => comments,
          :likes => likes,
          :user_likes => stream[:likes][:user_likes]
        }
      end
      if comment_like_ids.length > 0
        comment_likes = self.exec_fql <<-FQL, token
          SELECT object_id, post_id, user_id
          FROM like
          WHERE post_id IN ('#{comment_like_ids.keys.join("','")}')
        FQL
        
        comment_likes.map! do |comment_like|
          {
            :provider_id => Provider.facebook.id,
            :post_key => comment_like[:post_id].to_s,
            :user_key => comment_like[:user_id].to_s
          }
        end
      else
        comment_likes = []
      end
      
      {:streams => streams, :comment_likes => comment_likes}
    end
    
    # fetch post
    def self.post token, params
      post_key = params[:post_key]||raise(ArgumentError, 'luck of params[:post_key]')
      begin
        post = FbGraph::Post.fetch(post_key, :access_token => token)
      rescue
        nil
      end
    end
    
    # post to stream
    def self.post! token, params
      target = params[:target]||'user'
      target_id = params[:target_id]||'me'
      case target
        when 'user'
          if target_id == 'me'
            target_obj = FbGraph::User.me(token)
          else
            target_obj = FbGraph::User.new(target_id, :access_token => token)
          end
        when 'page'
          target_obj = FbGraph::Page.new(target_id, :access_token => token)
        when 'group'
          target_obj = FbGraph::Group.new(target_id, :access_token => token)
        else
          raise ArgumentError
      end
      
      begin
        post = target_obj.feed!(
          :message => params[:message],
          :picture => params[:picture],
          :link => params[:link],
          :name => params[:name],
          :description => params[:description],
          :actions => params[:actions],
          :properties => params[:properties]
        )
      rescue => e
        if e.message =~ /(Feed action request limit reached)/
          raise RequestLimitException, $1
        end
        return e
      end
      post
    end
    
    # comment to post
    def self.comment! token, params
      message = params[:message] || ''
      begin
        post = self.post token, params
        if post.nil?
          raise SocialSync::FacebookException, 'post not found'
        end
        post.comment!({:message => message})
      rescue => e
        e.backtrace.each { |line| put   line }
      end
    end
    
    # destroy post
    def self.destroy! token, params
      begin
        post = self.post token, params
        if post.nil?
          raise SocialSync::FacebookException, 'post not found'
        end
        post.destroy()
      rescue => e
        e
      end
    end
    
    # like to post
    def self.like! token, params
      begin
        post_key = params[:post_key]||raise(ArgumentError, 'luck of params[:post_key]')
        post = FbGraph::Post.new(post_key, :access_token => token)
        if post.nil?
          raise SocialSync::FacebookException, 'post not found'
        end
        post.like!()
      rescue => e
        raise SocialSync::FacebookException, 'post not found'
      end
    end
    
    # cancel like to post
    def self.unlike! token, params
      begin
        post_key = params[:post_key]||raise(ArgumentError, 'luck of params[:post_key]')
        post = FbGraph::Post.new(post_key, :access_token => token)
        if post.nil?
          raise SocialSync::FacebookException, 'post not found'
        end
        post.unlike!()
      rescue => e
        raise SocialSync::FacebookException, 'post not found'
      end
    end
    
    # fetch test users
    def self.test_users
      begin
        app = FbGraph::Application.new(FacebookConfig.app_id, :secret => FacebookConfig.app_secret)
        testusers = app.test_users
      rescue HTTPClient::ReceiveTimeoutError => e
        raise SocialSync::FacebookException, 'facebook connect fail.'
      rescue HTTPClient::KeepAliveDisconnected => e
        raise SocialSync::FacebookException, 'facebook connect fail.'
      end
    end
    
    # create test user
    def self.test_user!
      begin
        app = FbGraph::Application.new(FacebookConfig.app_id, :secret => FacebookConfig.app_secret)
        testuser = app.test_user!(:permissions => FacebookConfig.scope, :installed => true, :name=>Faker::Name.name)
      rescue HTTPClient::ReceiveTimeoutError => e
        raise SocialSync::FacebookException, 'facebook connect fail.'
      rescue HTTPClient::KeepAliveDisconnected => e
        raise SocialSync::FacebookException, 'facebook connect fail.'
      end
    end
    
    # delete all test users
    def self.destroy_test_users!
      testusers = self.test_users
      testusers.each do |test_user|
        test_user.destroy()
      end
    end
    
    private
    ###################################################################
    # execuete FQL bia FbGraph liblary
    # 
    def self.exec_fql fql, token
      begin
        res = FbGraph::Query.new(fql).fetch(token)
      rescue TypeError => e
        # ignore TypeError which is not facebook error but local.
        res
      rescue FbGraph::NotFound => e
        []
      rescue HTTPClient::ReceiveTimeoutError => e
        raise SocialSync::FacebookException, 'facebook connect fail.'
      rescue HTTPClient::KeepAliveDisconnected => e
        raise SocialSync::FacebookException, 'facebook connect fail.'
      end
    end
    
    def self.format_profile user
      {
        :id => user['id'].to_s,
        :name => user['name'],
        :pic => user['pic'],
        :pic_square => user['pic_square'],
        :pic_small => user['pic_small'],
        :pic_big => user['pic_big'],
        :type => user['type'],
        :username => user['username'],
        :url => user['url'],
        :provider => :facebook
      }
    end
  end
end

# hack
module FbGraph
  class Property
    include Comparison

    attr_accessor :name, :text, :href

    def initialize(attriutes = {}) 
    end 
  end 
end