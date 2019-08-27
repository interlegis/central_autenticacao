class AddExtIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :ext_id, :string
  end
end
