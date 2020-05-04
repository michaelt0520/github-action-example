# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    display_name          { Faker::Name.name }
    email                 { Faker::Internet.email }
    password              { Faker::Internet.password }
    password_confirmation { password }

    trait :with_account_bank_and_transactions do
      after(:create) do |user|
        account_bank = create(:account, user: user)
        5.times { account_bank.transactions.create(transaction_type: %w[withdraw deposit].sample, amount: rand(100)) }
      end
    end
  end
end
