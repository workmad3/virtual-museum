FactoryGirl.define do
  factory :page do
    title 'A page title'
    content 'Sample page content'
    association :user
  end
end