# frozen_string_literal: true

class Transaction < ApplicationRecord
  extend Enumerize
  TRANSACTION_TYPE = %w[withdraw deposit].freeze

  belongs_to :account

  enumerize :transaction_type, in: TRANSACTION_TYPE, scope: true

  validates :amount,           presence: true
  validates :transaction_type, presence: true, inclusion: { in: TRANSACTION_TYPE }

  delegate :bank, to: :account, prefix: true

  def created_date
    created_at.strftime('%d %b. %Y')
  end
end
