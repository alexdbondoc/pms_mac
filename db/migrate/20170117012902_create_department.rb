class CreateDepartment < ActiveRecord::Migration[5.0]
  def change
    create_table :departments do |t|
    	t.string :name
    	t.integer :group_id
    end
  end
end
