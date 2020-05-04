# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let!(:user)    { create :user }
  let!(:account) { create :account, user: user, bank: 'VIB', name: 'dummy' }

  before { authenticate_user(user) }

  describe 'GET #index' do
    let!(:transactions) { create_list :transaction, 10, account: account }

    context 'render page transaction index with size is 10' do
      subject { get :index, params: { account_id: account.id } }

      it do
        is_expected
        expect(response.code).to eq '200'
        expect(subject).to render_template(:index)
        expect(assigns(:transactions).size).to eq 10
      end
    end

    context 'when user not exists' do
      subject { get :index, params: { account_id: account.id + 1 } }

      its(:code) { is_expected.to eq '404' }
      its(:body) { is_expected.to render_template(:page_404) }
    end
  end

  describe 'GET #new' do
    context 'render template new' do
      subject { get :new, params: { account_id: account.id } }

      its(:code) { is_expected.to eq '200' }
      its(:body) { is_expected.to render_template(:new) }
    end

    context 'when user not exists' do
      subject { get :new, params: { account_id: account.id + 1 } }

      its(:code) { is_expected.to eq '404' }
      its(:body) { is_expected.to render_template(:page_404) }
    end
  end

  describe 'POST #create' do
    context 'when params transaction is invalid' do
      subject { post :create, params: { account_id: account.id, transaction: { amount: 10.0, transaction_type: 'withdraws' } } }

      it do
        is_expected
        expect(response.code).to eq '200'
        expect(flash[:alert]).to be_truthy
        expect(subject).to render_template(:new)
      end
    end

    context 'when transaction not exists' do
      subject { post :create, params: { account_id: account.id + 1, transaction: { amount: 10.0, transaction_type: 'withdraws' } } }

      its(:code) { is_expected.to eq '404' }
      its(:body) { is_expected.to render_template(:page_404) }
    end

    context 'when params transaction is valid' do
      subject { post :create, params: { account_id: account.id, transaction: { amount: 10.0, transaction_type: 'withdraw' } } }

      it { expect { subject }.to change(Transaction, :count).by(1) }

      it do
        is_expected
        expect(response.code).to eq '302'
        expect(subject).to redirect_to account_transactions_path
      end
    end
  end

  describe 'GET #edit' do
    let!(:transaction) { create :transaction, account: account, amount: 100.0, transaction_type: 'withdraw' }

    context 'render template edit' do
      subject { get :edit, params: { account_id: account.id, id: transaction.id } }

      its(:code) { is_expected.to eq '200' }
      its(:body) { is_expected.to render_template(:edit) }
    end

    context 'transaction not found' do
      subject { get :edit, params: { account_id: account.id, id: transaction.id + 1 } }

      its(:code) { is_expected.to eq '404' }
      its(:body) { is_expected.to render_template(:page_404) }
    end
  end

  describe 'PATCH #update' do
    let!(:transaction) { create :transaction, account: account, amount: 100.0, transaction_type: 'withdraw' }

    context 'when params is invalid' do
      subject { patch :update, params: { account_id: account.id, id: transaction.id, transaction: { amount: 100.0, transaction_type: 'withdraws' } } }

      it do
        is_expected
        expect(response.code).to eq '200'
        expect(flash[:alert]).to be_truthy
        expect(subject).to render_template(:edit)
      end
    end

    context 'when params is valid' do
      subject { patch :update, params: { account_id: account.id, id: transaction.id, transaction: { amount: 10.0, transaction_type: 'withdraw' } } }

      it do
        is_expected
        expect(response.code).to eq '302'
        expect(subject).to redirect_to account_transactions_path
      end
    end

    context 'when transaction not found' do
      subject { patch :update, params: { account_id: account.id, id: transaction.id + 1, transaction: { amount: 100.0, transaction_type: 'withdraws' } } }

      its(:code) { is_expected.to eq '404' }
      its(:body) { is_expected.to render_template(:page_404) }
    end
  end

  describe 'DELETE #destroy' do
    let!(:transaction) { create :transaction, account: account, amount: 100.0, transaction_type: 'withdraw' }

    context 'when transaction not found' do
      subject { patch :destroy, params: { account_id: account.id, id: transaction.id + 1 } }

      its(:code) { is_expected.to eq '404' }
      its(:body) { is_expected.to render_template(:page_404) }
    end

    context 'when destroy success transaction' do
      subject { patch :destroy, params: { account_id: account.id, id: transaction.id } }

      it { expect { subject }.to change(Transaction, :count).by(-1) }

      it do
        is_expected
        expect(response.code).to eq '302'
        expect(subject).to redirect_to account_transactions_path
      end
    end
  end
end
