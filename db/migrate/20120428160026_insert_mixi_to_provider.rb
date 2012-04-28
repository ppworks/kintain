class InsertMixiToProvider < ActiveRecord::Migration
  def up
    execute "INSERT INTO providers(id, name, created_at, updated_at)VALUES(4, 'mixi', NOW(), NOW())"
  end

  def down
    execute "DELETE FROM providers WHERE name IN('mixi')"
  end
end
