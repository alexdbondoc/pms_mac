class CreateReceives < ActiveRecord::Migration[5.0]
  def change
    create_table :receives do |t|
    	t.string :receive_num
    	t.integer :user_id
    	t.string :dr_num
    	t.datetime :dr_date
    	t.string :invoice_num
    	t.datetime :invoice_date
    	t.string :delivery_type
    	t.integer :order_id
    	t.string :gross
    	t.string :tax
    	t.string :net
      t.timestamps
    end
  end
end
