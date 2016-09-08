class CreateReferenceTags < ActiveRecord::Migration
  def change
    create_table :reference_tags, id: :uuid do |t|
      t.uuid :reference_id
      t.uuid :tag_id

      t.timestamps null: false
    end

    drop_join_table :References, :Tags
  end
end
