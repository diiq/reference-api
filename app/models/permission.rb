class Permission < ActiveRecord::Base
  # Columns:
  #
  # name: string
  # Identifies the behavior of the permission -- like "view" or "submit_for_review" or w/e
  #
  # created_at: datetime
  # updated_at: datetime

  belongs_to :role
end
