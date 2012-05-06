class EventName < ActiveRecord::Base
  validates_presence_of :name
  attr_accessible :event_id, :name, :user_id
  belongs_to :event
  belongs_to :user

  def self.list user
    event_names = []
    Event.all.each do|event|
      data = {:event_id => event.id, :user_id => user.id}
      event_name = self.where(data).order('id DESC').first
      if event_name.present?
        event_names << event_name
      else
        event_names << self.new(data.merge :name => event.label)
      end
    end
    event_names
  end

  def self.update_by_hash hash, user
    res = {}
    self.list(user).each do|event_name|
      event_id = event_name.event_id
      new_name = hash[event_id.to_s]
      unless event_name.name === new_name 
        res[event_id] = EventName.create({
          :event_id => event_id,
          :user_id => user.id,
          :name => new_name,
        })
      end
    end
    res
  end
end
