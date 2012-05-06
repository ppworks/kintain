class AddScopeIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :scope_id, :integer, :default => 1
  end
end
