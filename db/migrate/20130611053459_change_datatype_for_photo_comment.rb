class ChangeDatatypeForPhotoComment < ActiveRecord::Migration
  def change
    change_column :photos, :comment, :text
  end
end
