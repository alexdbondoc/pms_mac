class AddStatus < ActiveRecord::Migration[5.0]
  def change
    add_column :consolidates, :status, :string
  end
end
