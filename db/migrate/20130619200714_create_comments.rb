class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, :null => false
      t.integer :object_id, :null => false
      t.string :object_type, :null => false
      t.text :comment, :null => false

      t.timestamps
    end
  end
end
