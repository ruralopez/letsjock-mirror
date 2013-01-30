class CreateUserEvents < ActiveRecord::Migration
  def change
    create_table :user_events, :id => false do |t|
      t.references :user, :null => false
      t.references :event, :null => false

      t.timestamps
    end
    add_index :user_events, [:user_id, :event_id], :unique => true
  end
end
