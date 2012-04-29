class PostsProvider < ActiveRecord::Base
  attr_accessible :content, :post_id, :post_key
end
