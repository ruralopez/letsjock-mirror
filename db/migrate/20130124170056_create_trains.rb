class CreateTrains < ActiveRecord::Migration
  def change
    create_table :trains do |t|
      t.integer :user_id
      t.integer :sport_id
      t.integer :team_id
      t.integer :trainer_id
      t.string :name
      t.datetime :init
      t.datetime :end

      t.timestamps
    end
  end
end
