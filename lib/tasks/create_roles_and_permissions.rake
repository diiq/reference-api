namespace :permissions do
  desc 'Creates base roles and permissions'
  task seed: 'environment' do
    Role.create_all
  end
end
