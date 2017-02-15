class ChangeColumnNameOnOrder < ActiveRecord::Migration[5.0]
  def change
  	rename_column :orders, :gross, :status
  end
end
