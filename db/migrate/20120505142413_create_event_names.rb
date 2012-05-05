class CreateEventNames < ActiveRecord::Migration
  def change
    create_table :event_names do |t|
      t.integer :user_id, :null => false
      t.integer :event_id, :null => false
      t.string :name, :null => false

      t.timestamps
    end
  end
end
