class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|

      t.references :publisher
      t.references :post
      t.references :user
      t.references :event
      t.references :photo
      t.references :video
      t.string :act_type
      t.timestamps
    end
  end
end
