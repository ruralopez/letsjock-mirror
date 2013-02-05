class CreateExams < ActiveRecord::Migration
  def change
    create_table :exams do |t|
      t.string :name
      t.string :iso
      t.integer :country_id

      t.timestamps
    end
  end
end
