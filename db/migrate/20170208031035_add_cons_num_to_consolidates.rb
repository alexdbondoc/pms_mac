class AddConsNumToConsolidates < ActiveRecord::Migration[5.0]
  def change
    add_column :consolidates, :ConsNum, :string
  end
end
