class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :id1
      t.integer :id2
      t.string :type1
      t.string :type2

      t.timestamps
    end
  end
end
