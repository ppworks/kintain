class CreatePostsProviders < ActiveRecord::Migration
  def change
    create_table :posts_providers do |t|
      t.integer :post_id
      t.integer :provider_id
      t.string :post_key
      t.string :content

      t.timestamps
    end
    add_index :posts_providers, [:post_id], :name => :idx_post_id_on_posts_providers
  end
end
