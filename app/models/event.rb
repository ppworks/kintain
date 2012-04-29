class Event < ActiveRecord::Base
  attr_accessible :name

  def label
    I18n.t("event.records.#{self.id}")
  end
end
