class ChangeDataTypeForResume < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.change :resume, :text
    end
  end

  def down
    change_table :users do |t|
      t.change :resume, :string
    end
  end
end
