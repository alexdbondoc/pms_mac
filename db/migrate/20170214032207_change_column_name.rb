class ChangeColumnName < ActiveRecord::Migration[5.0]
  def change
  	rename_column :orders, :tax, :user_id
  end
end
