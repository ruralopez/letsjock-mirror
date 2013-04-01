class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :user_id
      t.integer :sport_id
      t.integer :work_id
      t.string :name
      t.string :category
      t.date :init
      t.date :end
      t.boolean :as_athlete

      t.timestamps
    end
  end
end
