# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    amount           { Faker::Number.decimal(l_digits: 2) }
    transaction_type { 'withdraw' }
  end
end
