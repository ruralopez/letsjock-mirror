class ChangeDatatypeForStatsInfo < ActiveRecord::Migration
  def change
    change_column :stats, :info, :integer
  end
end
