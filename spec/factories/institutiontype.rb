# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :institutiontype do
    # => Institutiontype(id: integer, name: string, created_at: datetime, updated_at: datetime)

    sequence(:name) { |n| (Faker::Company.industry + ' ' + (n + rand(100_000)).to_s).to_s }
  end
end
