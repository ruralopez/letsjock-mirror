class ChangeDataTypeForValue < ActiveRecord::Migration
  def up
     change_table :results do |t|
      t.change :value, :string
    end
  end

  def down
    change_table :results do |t|
      t.change :value, :integer
    end
  end
end
