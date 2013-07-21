class AddSpeedToUser < ActiveRecord::Migration
  def change
	add_column :users, :speed_25, :decimal, :precision => 10, :scale => 2
	add_column :users, :speed_50, :decimal, :precision => 10, :scale => 2
	add_column :users, :speed_100, :decimal, :precision => 10, :scale => 2
  end
end
