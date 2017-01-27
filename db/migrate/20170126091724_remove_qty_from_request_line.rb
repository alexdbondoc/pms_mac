class RemoveQtyFromRequestLine < ActiveRecord::Migration[5.0]
  def change
    remove_column :request_lines, :qty, :integer
  end
end
