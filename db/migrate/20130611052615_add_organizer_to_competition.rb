class AddOrganizerToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :organizer, :string
    add_column :competitions, :place, :string
  end
end
