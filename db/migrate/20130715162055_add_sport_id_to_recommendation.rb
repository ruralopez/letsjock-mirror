class AddSportIdToRecommendation < ActiveRecord::Migration
  def change
    add_column :recommendations, :sport_id, :integer, :after => :writer_type
    add_column :recommendations, :status, :boolean, :after => :sport_id
  end
end
