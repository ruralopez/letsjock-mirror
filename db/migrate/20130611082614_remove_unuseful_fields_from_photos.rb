class RemoveUnusefulFieldsFromPhotos < ActiveRecord::Migration
  def up
    remove_column :photos, :competition_id
    remove_column :photos, :recognition_id
    remove_column :photos, :result_id
    remove_column :photos, :team_id
    remove_column :photos, :train_id
    remove_column :photos, :trainee_id
    remove_column :photos, :work_id
  end

  def down
    add_column :photos, :work_id, :integer
    add_column :photos, :trainee_id, :integer
    add_column :photos, :train_id, :integer
    add_column :photos, :team_id, :integer
    add_column :photos, :result_id, :integer
    add_column :photos, :recognition_id, :integer
    add_column :photos, :competition_id, :integer
  end
end
