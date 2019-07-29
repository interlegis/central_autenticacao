class CreateApiAccesses < ActiveRecord::Migration[5.2]
  def change
    create_table :api_accesses do |t|
      t.string :key
      t.references :user, foreign_key: true
      t.references :api_accesses_level, foreign_key: true

      t.timestamps
    end
  end
end
