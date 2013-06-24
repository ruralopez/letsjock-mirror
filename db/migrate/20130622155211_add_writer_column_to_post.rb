class AddWriterColumnToPost < ActiveRecord::Migration
  def change
    add_column :posts, :writer_id, :integer, :after => :event_id
  end
end
