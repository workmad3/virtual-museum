
FactoryGirl.define do

  factory :previous_page do

    sequence(:title) {|n| "Past Title #{n}" }
    sequence(:content) {|n| "Past Content #{n}" }

    association :page
    association :user
  end
end
