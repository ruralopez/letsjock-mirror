class AddOwnerNameToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :owner_name, :string
  end
end
