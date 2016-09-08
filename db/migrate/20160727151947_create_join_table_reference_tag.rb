class CreateJoinTableReferenceTag < ActiveRecord::Migration
  def change
    create_join_table :References, :Tags do |t|
      t.index [:reference_id, :tag_id]
      t.index [:tag_id, :reference_id]
    end
  end
end
