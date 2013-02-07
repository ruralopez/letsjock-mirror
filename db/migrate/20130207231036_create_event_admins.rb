class CreateEventAdmins < ActiveRecord::Migration
  def change
    create_table :event_admins, :id => false do |t|
      t.references :user, :null => false
      t.references :event, :null => false

      t.timestamps
    end
    add_index :event_admins, [:user_id, :event_id], :unique => true
  end
end
