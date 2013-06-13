class CreateUserAdmins < ActiveRecord::Migration
  def change
    create_table :user_admins do |t|
      t.references :user, :null => false
      t.integer :admin_id, :null => false

      t.timestamps
    end
    add_index :user_admins, [:user_id, :admin_id], :unique => true
  end
end
