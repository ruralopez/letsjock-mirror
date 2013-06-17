class AddCategoryToResult < ActiveRecord::Migration
  def change
    add_column :results, :category, :string
  end
end
