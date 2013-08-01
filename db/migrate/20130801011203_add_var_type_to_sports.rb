class AddVarTypeToSports < ActiveRecord::Migration
  def change
	add_column :sports, :var_type, :boolean, :default => false
  end
end
