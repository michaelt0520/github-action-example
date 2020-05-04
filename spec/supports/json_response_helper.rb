# frozen_string_literal: true

module JsonResponseHelper
  def response_404
    { message: 'Not Found' }
  end

  def response_409
    { message: 'Conflict' }
  end

  def response_422(errors)
    { message: 'Unprocessable Entity', errors: errors }
  end

  def response_transaction
    {
      id: Integer,
      account_id: Integer,
      amount: String,
      bank: String,
      transaction_type: String,
      created_date: String
    }
  end
end
