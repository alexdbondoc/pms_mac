class AddQtyToRequestLines < ActiveRecord::Migration[5.0]
  def change
    add_column :request_lines, :qty, :integer
  end
end
