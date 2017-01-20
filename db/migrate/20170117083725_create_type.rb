class CreateType < ActiveRecord::Migration[5.0]
  def change
    create_table :types do |t|
    	t.string :name
    	t.integer :category_id
    end
  end
end
