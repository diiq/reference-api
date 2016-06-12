class CreateReferences < ActiveRecord::Migration
  def change
    create_table :references, id: :uuid do |t|
      t.string :notes
      t.timestamps null: false
    end
  end
end
