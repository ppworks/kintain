class InsertDefaultToScope < ActiveRecord::Migration
  def up
    execute "INSERT INTO scopes(id, name, created_at, updated_at)VALUES(1, 'public', NOW(), NOW()), (2, 'private', NOW(), NOW())"
  end

  def down
    execute "DELETE FROM providers WHERE name IN('public', 'private')"
  end
end
