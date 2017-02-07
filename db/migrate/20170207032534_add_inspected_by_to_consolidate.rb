class AddInspectedByToConsolidate < ActiveRecord::Migration[5.0]
  def change
    add_column :consolidates, :inspected_by, :integer
  end
end
