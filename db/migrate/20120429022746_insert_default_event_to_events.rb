class InsertDefaultEventToEvents < ActiveRecord::Migration
  def up
    execute "INSERT INTO events(id, priority, name, created_at, updated_at)VALUES
    (1, 1, 'leave home', NOW(), NOW()),
    (2, 2, 'come office', NOW(), NOW()),
    (3, 3, 'leave office', NOW(), NOW()),
    (4, 4, 'come home', NOW(), NOW()),
    (5, 5, 'eat pizza', NOW(), NOW())
    "
  end

  def down
    execute "DELETE FROM events WHERE id IN(1, 2, 3, 4, 5)"
  end
end
