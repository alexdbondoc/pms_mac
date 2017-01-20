class CreateDesignation < ActiveRecord::Migration[5.0]
  def change
    create_table :designations do |t|
    	t.string :name
    end
  end
end
