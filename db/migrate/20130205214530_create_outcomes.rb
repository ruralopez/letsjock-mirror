class CreateOutcomes < ActiveRecord::Migration
  def change
    create_table :outcomes do |t|
      t.integer :user_id
      t.integer :exam_id
      t.string :score

      t.timestamps
    end
  end
end
