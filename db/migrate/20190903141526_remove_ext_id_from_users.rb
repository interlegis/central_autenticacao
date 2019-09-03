class RemoveExtIdFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :ext_id, :string
  end
end
