module RolesList
  def create_permanent_owner
    ensure_exists(:permanent_owner) do |role|
      role.ensure_permission_exists(:always_own)
      role.ensure_permission_exists(:view)
      role.ensure_permission_exists(:edit_references)
    end
  end

  def create_all
    create_permanent_owner
  end
end
