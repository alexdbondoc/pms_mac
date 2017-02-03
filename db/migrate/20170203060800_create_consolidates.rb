class CreateConsolidates < ActiveRecord::Migration[5.0]
  def change
    create_table :consolidates do |t|
    	t.integer :category_id
    	t.integer :user_id
    	t.integer :department_id
    	t.integer :officer_id
    	t.datetime :group_head_approve
    	t.integer :received_by
    	t.datetime :ppmd_head_approve
    	t.string :purpose
      t.timestamps
    end
  end
end
