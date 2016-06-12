FactoryGirl.define do
  factory :permission do
    sequence(:name) { |n| "view_#{n}" }
  end
end
