class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :user_id
      t.integer :competition_id
      t.integer :recognition_id
      t.integer :result_id
      t.integer :team_id
      t.integer :train_id
      t.integer :sport_id
      t.string :url
      t.string :title
      t.string :comment

      t.timestamps
    end
  end
end