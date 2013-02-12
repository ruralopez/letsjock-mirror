class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user, :null => false
      t.references :event, :null => false
      t.string :title
      t.string :content

      t.timestamps
    end
  end
end
