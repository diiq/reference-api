class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles, id: :uuid do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end
