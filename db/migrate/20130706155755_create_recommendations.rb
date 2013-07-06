class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.references :user, :null => false
      t.integer :writer_id, :null => false
      t.text :content, :null => false

      t.timestamps
    end
  end
end
