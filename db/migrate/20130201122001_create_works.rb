class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.integer :user_id
      t.integer :sport_id
      t.string :placename
      t.string :position
      t.string :country
      t.date :init
      t.date :end

      t.timestamps
    end
  end
end
