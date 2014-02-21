
FactoryGirl.define do

  factory :page_state do

    sequence(:title) {|n| "Post Title #{n}" }
    sequence(:content) {|n| "Post Content #{n}" }

    association :page
    association :user
  end
end
