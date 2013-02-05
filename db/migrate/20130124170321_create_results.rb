class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :user_id
      t.integer :sport_id
      t.integer :competition_id
      t.integer :team_id
      t.string :position
      t.integer :value
      t.string :var
      t.date :date
      t.boolean :as_athlete

      t.timestamps
    end
  end
end
