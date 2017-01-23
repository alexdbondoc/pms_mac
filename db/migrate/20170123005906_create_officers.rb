class CreateOfficers < ActiveRecord::Migration[5.0]
  def change
    create_table :officers do |t|

      t.integer :user_id
      t.integer :department_id
      t.integer :designation_id
    end
  end
end
