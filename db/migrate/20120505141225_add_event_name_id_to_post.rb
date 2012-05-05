class AddEventNameIdToPost < ActiveRecord::Migration
  def change
    add_column :posts, :event_name_id, :integer, :null => false
  end
end
