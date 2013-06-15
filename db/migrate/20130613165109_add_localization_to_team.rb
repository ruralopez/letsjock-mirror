class AddLocalizationToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :localization, :string
  end
end
