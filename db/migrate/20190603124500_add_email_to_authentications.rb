class AddEmailToAuthentications < ActiveRecord::Migration[5.2]
  def change
    add_column :authentications, :email, :string
  end
end
