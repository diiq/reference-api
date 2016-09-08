class AddAttachmentToReference < ActiveRecord::Migration
  def change
    add_attachment :references, :image
  end
end
