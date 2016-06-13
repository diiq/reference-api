FactoryGirl.define do
  sequence(:email) { |n| "user_#{n}@example.com" }

  factory :user do
    email
    password "password"

    trait :with_permission do
      transient do
        to :view
        this FactoryGirl.create :reference
      end

      after :create do |user, evaluator|
        role = FactoryGirl.create :role 
        permission = FactoryGirl.create :permission, name: evaluator.to, role: role
        user.assign_as! role, to: evaluator.this
      end
    end
  end
end
