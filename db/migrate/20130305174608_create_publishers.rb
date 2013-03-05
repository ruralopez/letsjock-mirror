class CreatePublishers < ActiveRecord::Migration
  def change
    create_table :publishers do |t|

      t.references :user
      t.references :event
      t.string :pub_type
      t.timestamps

    end
  end
end
