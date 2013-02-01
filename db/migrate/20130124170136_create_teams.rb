class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :user_id
      t.integer :sport_id
      t.string :name
      t.date :init
      t.date :end

      t.timestamps
    end
  end
end
