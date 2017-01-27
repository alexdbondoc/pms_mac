class CreateRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :requests do |t|
    	t.integer :category_id
    	t.integer :user_id
    	t.datetime :date_created
    	t.integer :officer_id
    	t.integer :department_id
    	t.string :reason
    	t.string :status
    end
  end
end
