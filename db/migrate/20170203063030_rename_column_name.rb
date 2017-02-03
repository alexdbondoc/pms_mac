class RenameColumnName < ActiveRecord::Migration[5.0]
  def change
  	rename_column :consolidate_lines, :user_id, :consolidate_id
  end
end
