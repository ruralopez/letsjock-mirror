class AddAuxIdAndAuxTypeToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :aux_id, :integer
    add_column :notifications, :aux_type, :string
  end
end
