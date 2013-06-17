class CreateSponsorsEvents < ActiveRecord::Migration
  def change
    create_table :sponsors_events do |t|
      t.references :user, :null => false
      t.references :event, :null => false
      t.integer :category

      t.timestamps
    end
  end
end
