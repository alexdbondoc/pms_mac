class RemoveBrandIdFromConsolidateLine < ActiveRecord::Migration[5.0]
  def change
    remove_column :consolidate_lines, :brand_id, :integer
  end
end
