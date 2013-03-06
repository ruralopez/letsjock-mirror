class CreateNotifications < ActiveRecord::Migration
    def change
        create_table :notifications do |t|
          t.references :user
          t.integer :user2_id
          t.references :event
          t.boolean :read
          t.string :not_type

          t.timestamps
        end
    end
end
