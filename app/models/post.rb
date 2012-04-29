class Post < ActiveRecord::Base
  OFFICIAL_IDS = [1, 2, 3, 4]
  attr_accessible :event_id, :user_id
  belongs_to :event
  belongs_to :user

  def created_at_to_percent
    times = self.created_at.strftime('%X').split(':')
    (((times[0].to_i * 60 * 60 + times[1].to_i * 60 + times[2].to_i) / (24 * 60 * 60).to_f) * 100).to_i
  end

  def official?
    OFFICIAL_IDS.include? self.event_id 
  end

  def self.enough? posts
    event_ids = posts.map{|post|post.event_id}.uniq.sort
    event_ids.include?(1) && event_ids.include?(4)
  end
end
