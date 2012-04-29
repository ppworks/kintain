class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :event_id
      t.integer :user_id

      t.timestamps
    end
  end
end
