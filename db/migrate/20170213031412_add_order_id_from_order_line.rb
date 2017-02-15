class AddOrderIdFromOrderLine < ActiveRecord::Migration[5.0]
  def change
    add_column :order_lines, :order_id, :integer
  end
end
