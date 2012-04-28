class InsertDefaultProvider < ActiveRecord::Migration
  def up
    execute "INSERT INTO providers(id, name, created_at, updated_at)VALUES(1, 'facebook', NOW(), NOW()), (2, 'twitter', NOW(), NOW()), (3, 'github', NOW(), NOW())"
  end

  def down
    execute "DELETE FROM providers WHERE name IN('facebook', 'twitter')"
  end
end
