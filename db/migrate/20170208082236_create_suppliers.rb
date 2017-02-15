class CreateSuppliers < ActiveRecord::Migration[5.0]
  def change
    create_table :suppliers do |t|
    	t.string :name
    	t.string :address
    	t.string :web
    	t.string :email
    	t.string :tel
    	t.string :tin
    	t.string :fax
    	t.string :representative
      t.timestamps
    end
  end
end
