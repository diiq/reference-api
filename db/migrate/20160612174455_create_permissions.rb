class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions, id: :uuid do |t|
      t.string :name, null: false
      t.uuid :role_id
      t.timestamps null: false
    end
  end
end
