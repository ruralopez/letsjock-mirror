class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.integer :user_id
      t.string :name
      t.string :location
      t.integer :state_id
      t.integer :country_id
      t.string :degree
      t.date :init
      t.date :end
      t.integer :rank
      t.string :career
      t.string :gda
      t.string :ncaa

      t.timestamps
    end
  end
end
