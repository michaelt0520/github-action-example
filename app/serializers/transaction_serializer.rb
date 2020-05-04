# frozen_string_literal: true

class TransactionSerializer < ApplicationSerializer
  attributes :id, :account_id, :amount, :bank, :transaction_type, :created_date

  def bank
    object.account_bank
  end

  def created_date
    object.created_date
  end
end
