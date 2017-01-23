class CreateRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :requests do |t|

    	t.integer :category_id
    	t.integer :user_id
    	t.timestamps :date_created
    	t.integer :officer_id
    	t.integer :department_id
    	t.integer :type_id
    	t.integer :product_id
    	t.integer :qty
    	t.integer :unit
    	t.string :reason
    	t.string :status
    end
  end
end
