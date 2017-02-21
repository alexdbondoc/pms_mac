class CreateAssignLines < ActiveRecord::Migration[5.0]
  def change
    create_table :assign_lines do |t|
    	t.integer :assign_id
    	t.integer :inventory_id
    	t.string :inventory_number
    	t.integer :user_id
    end
  end
end
