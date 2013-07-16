class AddWriterTypeToRecommendation < ActiveRecord::Migration
  def change
    add_column :recommendations, :writer_type, :string, :after => :writer_id, :null => false
  end
end
