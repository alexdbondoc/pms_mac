class AddSpecificationFromConsolidateLine < ActiveRecord::Migration[5.0]
  def change
    add_column :consolidate_lines, :specification, :string
  end
end
