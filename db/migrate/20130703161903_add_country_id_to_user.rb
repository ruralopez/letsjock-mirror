class AddCountryIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :country_id, :integer, :after => :citybirth, :null => false
  end
end
