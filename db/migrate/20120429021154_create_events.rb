class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.integer :priority
      t.timestamps
    end
    add_index :events, [:priority], :name => :idx_priority_on_events
  end
end
