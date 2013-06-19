class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.integer :user_id
      t.string :type
      t.integer :info

      t.timestamps
    end
  end
end
