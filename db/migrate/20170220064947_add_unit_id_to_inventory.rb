class AddUnitIdToInventory < ActiveRecord::Migration[5.0]
  def change
    add_column :inventories, :unit_id, :integer
  end
end
