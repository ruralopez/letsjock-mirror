class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :user_id
      t.integer :sport_id
      t.integer :competition_id
      t.integer :team_id
      t.integer :value
      t.string :var
      t.string :description
      t.datetime :date

      t.timestamps
    end
  end
end
