class AddVarToSports < ActiveRecord::Migration
  def change
	add_column :sports, :var, :string, :default => "p"
  end
end
