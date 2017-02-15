class CreateOrderLines < ActiveRecord::Migration[5.0]
  def change
    create_table :order_lines do |t|
    	t.integer :type_id
    	t.integer :product_id
    	t.string :description
    	t.integer :qty
    	t.integer :unit_id
    	t.integer :unit_price
    	t.integer :amount
    	t.integer :consolidate_id
    end
  end
end
