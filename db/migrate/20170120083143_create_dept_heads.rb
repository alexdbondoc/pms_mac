class CreateDeptHeads < ActiveRecord::Migration[5.0]
  def change
    create_table :dept_heads do |t|
    	t.integer :user_id
    	t.string :empname
    	t.integer :department_id
    end
  end
end
