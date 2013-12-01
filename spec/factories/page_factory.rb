FactoryGirl.define do

  factory :page do

    sequence(:title) {|n| "Page Title #{n}" }
    sequence(:content) {|n| "Page Content #{n}" }

    association :user
  end
end