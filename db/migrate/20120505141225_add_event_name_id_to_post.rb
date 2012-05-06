class AddEventNameIdToPost < ActiveRecord::Migration
  def change
    add_column :posts, :event_name_id, :integer
  end
end
