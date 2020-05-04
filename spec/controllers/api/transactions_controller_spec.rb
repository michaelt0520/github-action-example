# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::TransactionsController, type: :controller do
  describe 'GET #index' do
    let!(:user)             { create :user }
    let!(:account_vib)      { create :account, user: user, bank: 'VIB', name: 'dummy1' }
    let!(:account_vcb)      { create :account, user: user, bank: 'VCB', name: 'dummy2' }
    let!(:transactions_vib) { create_list :transaction, 10, account: account_vib }
    let!(:transactions_vcb) { create_list :transaction, 5, account: account_vcb }

    context 'when params account id is nil and get 15 transactions' do
      subject { get :index, params: { user_id: user.id, account_id: nil } }

      its(:code) { is_expected.to eq '200' }
      its(:body) { is_expected.to be_json_as(Array.new(15) { response_transaction }) }
    end

    context 'when params account id not nil and get 10 transactions' do
      subject { get :index, params: { user_id: user.id, account_id: account_vib.id } }

      its(:code) { is_expected.to eq '200' }
      its(:body) { is_expected.to be_json_as(Array.new(10) { response_transaction }) }
    end
  end

  describe 'POST #create' do
    let!(:user)     { create :user }
    let!(:account)  { create :account, user: user, bank: 'VIB', name: 'dummy1' }

    context 'when params is invalid' do
      subject { post :create, params: { user_id: user.id, transaction: { account_id: account.id, mount: 100.0, transaction_type: 'abc' } } }

      its(:code) { is_expected.to eq '422' }
      its(:body) { is_expected.to be_json_as(response_422(transaction_type: Array)) }
    end

    context 'when params is valid' do
      subject { post :create, params: { user_id: user.id, transaction: { account_id: account.id, amount: 100.0, transaction_type: 'deposit' } } }

      its(:code) { is_expected.to eq '201' }
      its(:body) { is_expected.to be_json_as(response_transaction) }
    end

    context 'when user not exists' do
      subject { post :create, params: { user_id: user.id + 100, transaction: { account_id: account.id, amount: 100.0, transaction_type: 'deposit' } }, format: :json }

      its(:code) { is_expected.to eq '404' }
      its(:body) { is_expected.to be_json_as(response_404) }
    end
  end
end
