class AddHighlightToSportInfo < ActiveRecord::Migration
  def change
    add_column :recognitions, :highlight, :boolean
    add_column :competitions, :highlight, :boolean
    add_column :teams, :highlight, :boolean
    add_column :trains, :highlight, :boolean
  end
end
