class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :name

      t.timestamps
    end
    add_index :providers, :name, :name => 'idx_name_on_providers', :unique => true
  end
end
