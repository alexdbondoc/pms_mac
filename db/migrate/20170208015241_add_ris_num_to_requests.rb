class AddRisNumToRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :requests, :RISNum, :string
  end
end
