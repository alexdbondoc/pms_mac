class CreateReceiveLines < ActiveRecord::Migration[5.0]
  def change
    create_table :receive_lines do |t|
    	t.integer :typ_id
    	t.integer :product_id
    	t.string :description
    	t.integer :qty
    	t.integer :unit_id
    	t.integer :receiving_qty
    	t.integer :receive_id
      t.timestamps
    end
  end
end
