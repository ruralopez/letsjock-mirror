class AddBestMarkToResult < ActiveRecord::Migration
  def change
    add_column :results, :best_mark, :boolean
  end
end
