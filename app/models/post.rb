class Post < ActiveRecord::Base
  OFFICIAL_IDS = [1, 2, 3, 4]
  attr_accessible :event_id, :user_id
  belongs_to :event
  belongs_to :user
  belongs_to :event_name

  scope :one_day, lambda{|date|
    where("created_at >= ?", date.beginning_of_day)
    .where("created_at <= ?", date.end_of_day)
    .order("created_at ASC")
  }
  
  scope :one_month, lambda{|date|
    where("created_at >= ?", date.beginning_of_month)
    .where("created_at <= ?", date.end_of_month)
    .order("created_at DESC")
  }

  before_create :set_event_name_id

  def label
    if self.event_name.present?
      self.event_name.name
    else
      self.event.label
    end
  end
  
  def created_at_to_percent
    times = self.created_at.strftime('%X').split(':')
    (((times[0].to_i * 60 * 60 + times[1].to_i * 60 + times[2].to_i) / (24 * 60 * 60).to_f) * 100).to_i
  end

  def official?
    OFFICIAL_IDS.include? self.event_id 
  end

  def self.enough? posts
    event_ids = posts.map{|post|post.event_id}.uniq.sort
    (event_ids.include?(1) || event_ids.include?(2)) && (event_ids.include?(3) || event_ids.include?(4))
  end

  def self.convert_monthly_chart date, posts
      res = [nil] 
      1.upto(date.end_of_month.day) do |day|
        res[day] = []
      end
      posts.each do|post|
        day = post.created_at.strftime('%d')
        res[day.to_i] << post if post.official?
      end
      res
  end

  private
  def set_event_name_id
    event_name = self.user.event_names.where(:event_id => self.event_id).order('id DESC').first
    if event_name.present?
      self.event_name_id = event_name.id
    else
      self.event_name_id = 0
    end
    true
  end
end
