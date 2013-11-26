FactoryGirl.define do

  factory :page do

    sequence(:title) {|n| "Past Title #{n}" }
    sequence(:content) {|n| "Past Content #{n}" }

    association :user
  end
end