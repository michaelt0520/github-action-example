# frozen_string_literal: true

class Api::TransactionsController < Api::BaseController
  skip_before_action :authenticate_user!
  before_action      :set_user, only: %i[index create]

  def index
    account      = @user.accounts.find_by(id: params[:account_id])
    transactions = account.nil? ? @user.transactions : account.transactions

    render json: transactions, each_serializer: TransactionSerializer, status: :ok
  end

  def create
    transaction = @user.transactions.new(params_transaction)
    if transaction.valid?
      transaction.save
      render json: transaction, serializer: TransactionSerializer, status: :created
    else
      render_422(transaction.errors.messages)
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def params_transaction
    params.require(:transaction).permit(:account_id, :amount, :transaction_type)
  end
end
