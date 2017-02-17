class UpdateColumnName < ActiveRecord::Migration[5.0]
  def change
  	rename_column :receive_lines, :typ_id, :type_id
  end
end
