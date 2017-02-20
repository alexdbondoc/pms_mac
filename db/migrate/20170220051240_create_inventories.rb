class CreateInventories < ActiveRecord::Migration[5.0]
  def change
    create_table :inventories do |t|
    	t.string :inventory_number
    	t.integer :receive_id
    	t.integer :category_id
    	t.integer :type_id
    	t.integer :product_id
    	t.integer :qty
    	t.string :description
    	t.string :status
      t.timestamps
    end
  end
end
