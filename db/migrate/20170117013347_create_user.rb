class CreateUser < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
    	t.string :empname
    	t.string :email
    	t.string :address
    	t.string :contact_number
        t.integer :departmet_id
        t.integer :designation_id
    	t.string :password_digest
    end
  end
end
