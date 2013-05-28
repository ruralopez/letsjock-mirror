class AddLatitudesToEvents < ActiveRecord::Migration
  def change
    add_column :events, :lat, :string
    add_column :events, :lon, :string
  end
end
