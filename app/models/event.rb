class Event < ActiveRecord::Base
  attr_accessible :name

  default_scope order(:priority)
  def label
    I18n.t("event.records.#{self.id}")
  end
end
