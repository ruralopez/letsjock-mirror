class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.integer :user_id
      t.integer :sport_id
      t.integer :event_id
      t.string :name
      t.date :init
      t.date :end

      t.timestamps
    end
  end
end
