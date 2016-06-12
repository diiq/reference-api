class Assignment < ActiveRecord::Base
  # Columns
  #
  # created_at: datetime
  # updated_at: datetime
  # 
  belongs_to :user
  belongs_to :role
  belongs_to :object, polymorphic: true
end
