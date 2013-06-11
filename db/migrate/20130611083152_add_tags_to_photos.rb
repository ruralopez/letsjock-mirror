class AddTagsToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :tags, :text
  end
end
