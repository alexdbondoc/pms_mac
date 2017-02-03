class CreateConsolidateLines < ActiveRecord::Migration[5.0]
  def change
    create_table :consolidate_lines do |t|
    	t.integer :request_id
    	t.integer :type_id
    	t.integer :product_id
    	t.integer :qty
    	t.integer :unit_id
    	t.integer :user_id
    end
  end
end
