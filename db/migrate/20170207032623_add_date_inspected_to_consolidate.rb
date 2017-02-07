class AddDateInspectedToConsolidate < ActiveRecord::Migration[5.0]
  def change
    add_column :consolidates, :inspected_date, :datetime
  end
end
