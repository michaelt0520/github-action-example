# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :set_account

  def index
    @transactions = @account.transactions
  end

  def new
    @transaction = @account.transactions.new
  end

  def create
    @transaction = @account.transactions.new(params_transaction)
    if @transaction.valid?
      @transaction.save
      redirect_to account_transactions_path
    else
      flash.now[:alert] = 'Something wrong!'
      render :new
    end
  end

  def edit
    @transaction = @account.transactions.find(params[:id])
  end

  def update
    @transaction = @account.transactions.find(params[:id])
    if @transaction.update(params_transaction)
      redirect_to account_transactions_path
    else
      flash.now[:alert] = 'Something wrong!'
      render :edit
    end
  end

  def destroy
    @account.transactions.find(params[:id]).destroy
    redirect_to account_transactions_path
  end

  private

  def set_account
    @account = Account.find(params[:account_id])
  end

  def params_transaction
    params.require(:transaction).permit(:transaction_type, :amount)
  end
end
