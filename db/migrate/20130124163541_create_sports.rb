class CreateSports < ActiveRecord::Migration
  def change
    create_table :sports do |t|
      t.integer :parent_id
      t.string :name
      t.string :fullpath

      t.timestamps
    end
  end
end
