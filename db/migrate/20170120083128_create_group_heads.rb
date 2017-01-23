class CreateGroupHeads < ActiveRecord::Migration[5.0]
  def change
    create_table :group_heads do |t|
    	t.integer :user_id
    	t.integer :empname
    	t.integer :group_id
    end
  end
end
