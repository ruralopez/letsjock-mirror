class CreateTrainees < ActiveRecord::Migration
  def change
    create_table :trainees do |t|
      t.integer :user_id
      t.integer :sport_id
      t.integer :work_id
      t.string :name
      t.integer :trainee_id
      t.date :init
      t.date :end

      t.timestamps
    end
  end
end
