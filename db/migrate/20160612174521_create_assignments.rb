class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments, id: :uuid do |t|
      t.uuid :object_id
      t.string :object_type
      t.uuid :user_id
      t.uuid :role_id
      t.timestamps null: false
    end
  end
end
