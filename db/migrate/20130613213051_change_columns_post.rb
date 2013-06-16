class ChangeColumnsPost < ActiveRecord::Migration
  def up
    change_column :posts, :content, :text
    change_column :posts, :event_id, :integer, :null => true
  end

  def down
    change_column :posts, :content, :string
    change_column :posts, :event_id, :integer, :null => false
  end
end
