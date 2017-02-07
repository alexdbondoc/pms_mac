class AddBrandIdToConsolidateLine < ActiveRecord::Migration[5.0]
  def change
    add_column :consolidate_lines, :brand_id, :integer
  end
end
