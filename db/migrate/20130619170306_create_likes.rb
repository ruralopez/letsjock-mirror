class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :user, :null => false
      t.integer :object_id, :null => false
      t.string :object_type, :null => false

      t.timestamps
    end
    
    add_index :likes, [:user_id, :object_id, :object_type], :unique => true
  end
end
