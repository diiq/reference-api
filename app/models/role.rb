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

  def self.ensure_exists(name)
    role = Role.where(name: name).first_or_create!
    role.send(:reset_tracked_permissions)
    yield(role) if block_given?
    role.send(:delete_stray_permissions)
    role
  end

  def ensure_permission_exists(name)
    perm = self.permissions.where(name: name).first_or_create!
    ensured_permission_ids << perm.id
    perm
  end

  private

  def ensured_permission_ids
    @ensured_permission_ids ||= []
  end

  def reset_tracked_permissions
    @ensured_permission_ids = []
  end

  def delete_stray_permissions
    permissions.delete(permissions.where.not(id: ensured_permission_ids))
    reset_tracked_permissions
  end
end
