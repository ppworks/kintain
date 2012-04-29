class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :event_id
      t.integer :user_id

      t.timestamps
    end
    add_index :posts, [:user_id], :name => :idx_user_id_on_posts
  end
end
