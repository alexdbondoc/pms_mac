class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
    	t.string :PONumber
    	t.string :terms
    	t.date :delivery_date
    	t.integer :supplier_id
    	t.string :amount
    	t.string :tax
    	t.string :gross
      t.timestamps
    end
  end
end
