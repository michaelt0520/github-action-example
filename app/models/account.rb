# frozen_string_literal: true

class Account < ApplicationRecord
  extend Enumerize
  KIND_OF_BANK = %w[VCB ACB VIB].freeze

  belongs_to :user
  has_many   :transactions, dependent: :destroy

  enumerize :bank, in: KIND_OF_BANK, scope: true

  validates :name, presence: true
  validates :bank, presence: true, inclusion: { in: KIND_OF_BANK }

  def register_date
    created_at.strftime('%d %b. %Y')
  end
end
