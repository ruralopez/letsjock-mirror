class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.integer :user_id
      t.integer :sport_id
      t.integer :event_id
      t.integer :team_id
      t.integer :work_id
      t.string :team_name
      t.string :name
      t.date :init
      t.date :end
      t.boolean :as_athlete

      t.timestamps
    end
  end
end
