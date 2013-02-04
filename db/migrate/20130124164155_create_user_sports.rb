class CreateUserSports < ActiveRecord::Migration
  def change
    create_table :user_sports, :id => false do |t|
      t.references :user, :null => false
      t.references :sport, :null => false
      t.string :position

      t.timestamps
    end
    add_index :user_sports, [:user_id, :sport_id], :unique => true
  end
end
