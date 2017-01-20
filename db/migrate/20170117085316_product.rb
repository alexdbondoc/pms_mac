class Product < ActiveRecord::Migration[5.0]
  def change
  	create_table :products do |t|
    	t.string :name
    	t.integer :type_id
    end
  end
end
