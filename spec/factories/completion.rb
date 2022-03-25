# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :completion do
    inprogress { true }
    pass { false }
    failure { false }
    mustmakeup { false }
    dnf { false }
  end
end
