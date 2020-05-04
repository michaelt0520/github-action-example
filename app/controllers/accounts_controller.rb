# frozen_string_literal: true

class AccountsController < ApplicationController
  def index
    @accounts = current_user.accounts
  end

  def new
    @account = current_user.accounts.new
  end

  def create
    @account = current_user.accounts.new(params_account)
    if @account.valid?
      @account.save
      redirect_to accounts_path
    else
      flash.now[:alert] = 'Something wrong!'
      render :new
    end
  end

  def edit
    @account = current_user.accounts.find(params[:id])
  end

  def update
    @accounts = current_user.accounts.find(params[:id])
    if @accounts.update(params_account)
      redirect_to accounts_path
    else
      flash.now[:alert] = 'Something wrong!'
      render :edit
    end
  end

  def destroy
    current_user.accounts.find(params[:id]).destroy
    redirect_to accounts_path
  end

  private

  def params_account
    params.require(:account).permit(:name, :bank)
  end
end
