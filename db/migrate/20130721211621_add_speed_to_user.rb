class AddSpeedToUser < ActiveRecord::Migration
  def change
	add_column :users, :speed_25, :decimal
	add_column :users, :speed_50, :decimal
	add_column :users, :speed_100, :decimal
  end
end
