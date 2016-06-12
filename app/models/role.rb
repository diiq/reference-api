class Role < ActiveRecord::Base
  # Columns:
  #
  # name: string
  # Describes the role: "admin", "user", "tenant admin", etc.
  #
  # created_at: datetime
  # updated_at: datetime
  #
  has_many :assignments
  has_many :permissions
end
