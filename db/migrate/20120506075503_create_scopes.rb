class CreateScopes < ActiveRecord::Migration
  def change
    create_table :scopes do |t|
      t.string :name, :null => false

      t.timestamps
    end
  end
end
