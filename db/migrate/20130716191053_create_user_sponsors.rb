class CreateUserSponsors < ActiveRecord::Migration
  def change
    create_table :user_sponsors do |t|
      t.references :user, :null => false
      t.integer :sponsor_id, :null => false

      t.timestamps
    end
    
    add_index :user_sponsors, [:user_id, :sponsor_id], :unique => true
  end
end
