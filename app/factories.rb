require 'spec_helper'

FactoryGirl.define do
  factory :user do
    name "John Lennon"
    email "j@b.c"
    password 11111111
    password_confirmation 11111111
  end

=begin
  FactoryGirl.define do
    factory :page_content do
      name "MyString"
      content "MyText"
      creator ""
    end
  end
=end
end