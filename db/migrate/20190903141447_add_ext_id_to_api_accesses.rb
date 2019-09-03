class AddExtIdToApiAccesses < ActiveRecord::Migration[5.2]
  def change
    add_column :api_accesses, :ext_id, :string
  end
end
