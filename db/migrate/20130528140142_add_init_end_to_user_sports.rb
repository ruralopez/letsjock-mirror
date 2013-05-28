class AddInitEndToUserSports < ActiveRecord::Migration
  def change
    add_column :user_sports, :end, :date, :after => :position
    add_column :user_sports, :init, :date, :after => :position
  end
end
