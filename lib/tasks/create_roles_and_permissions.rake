namespace :permissions do
  desc 'Creates base roles and permissions'
  task seed: 'environment' do
    Role.ensure_exists(:permanent_owner) do |role|
      role.ensure_permission_exists(:always_own)
      role.ensure_permission_exists(:view)
    end
  end
end
