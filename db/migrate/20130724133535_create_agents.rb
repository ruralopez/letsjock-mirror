class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.references :user, :null => false
      t.string :name, :null => false
      t.string :lastname, :null => false
      t.string :email, :null => false
      t.string :phone

      t.timestamps
    end
  end
end
