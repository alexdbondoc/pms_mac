class CreateAssigns < ActiveRecord::Migration[5.0]
  def change
    create_table :assigns do |t|
    	t.integer :user_id
    	t.string :remarks
      t.timestamps
    end
  end
end
