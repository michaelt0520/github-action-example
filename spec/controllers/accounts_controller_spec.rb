# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  let!(:user) { create :user }

  before { authenticate_user(user) }

  describe 'GET #index' do
    let!(:accounts) { create_list :account, 2, user: user }

    before { authenticate_user(user) }

    context 'render page account index with account is 2' do
      subject { get :index }

      it do
        is_expected
        expect(response.code).to eq '200'
        expect(subject).to render_template(:index)
        expect(assigns(:accounts).size).to eq 2
      end
    end
  end

  describe 'GET #new' do
    context 'render template new' do
      subject { get :new }

      its(:code) { is_expected.to eq '200' }
      its(:body) { is_expected.to render_template(:new) }
    end
  end

  describe 'POST #create' do
    let!(:account) { create :account, user: user, bank: 'VCB', name: 'Dummy' }

    context 'when params account is invalid' do
      subject { post :create, params: { account: { bank: 'BIDV', name: 'Dummy Name' } } }

      it do
        is_expected
        expect(response.code).to eq '200'
        expect(flash[:alert]).to be_truthy
        expect(subject).to render_template(:new)
      end
    end

    context 'when account exists' do
      subject { post :create, params: { account: { bank: 'VCB', name: 'Dummy' } } }

      its(:code) { is_expected.to eq '409' }
    end

    context 'when params account is valid' do
      subject { post :create, params: { account: { bank: 'VIB', name: 'Dummy 2' } } }

      it { expect { subject }.to change(Account, :count).by(1) }

      it do
        is_expected
        expect(response.code).to eq '302'
        expect(subject).to redirect_to accounts_path
      end
    end
  end

  describe 'GET #edit' do
    let!(:account) { create :account, user: user, bank: 'VCB', name: 'Dummy' }

    context 'render template edit' do
      subject { get :edit, params: { id: account.id } }

      its(:code) { is_expected.to eq '200' }
      its(:body) { is_expected.to render_template(:edit) }
    end

    context 'account not found' do
      subject { get :edit, params: { id: account.id + 1 } }

      its(:code) { is_expected.to eq '404' }
      its(:body) { is_expected.to render_template(:page_404) }
    end
  end

  describe 'PATCH #update' do
    let!(:account) { create :account, user: user, bank: 'VCB', name: 'Dummy' }

    context 'when params is invalid' do
      subject { patch :update, params: { id: account.id, account: { bank: 'BIDV', name: nil } } }

      it do
        is_expected
        expect(response.code).to eq '200'
        expect(flash[:alert]).to be_truthy
        expect(subject).to render_template(:edit)
      end
    end

    context 'when params is valid' do
      subject { patch :update, params: { id: account.id, account: { bank: 'VIB', name: 'Dummy' } } }

      it do
        is_expected
        expect(response.code).to eq '302'
        expect(subject).to redirect_to accounts_path
      end
    end

    context 'when account not found' do
      subject { patch :update, params: { id: account.id + 1, account: { bank: 'VIB', name: 'Dummy' } } }

      its(:code) { is_expected.to eq '404' }
      its(:body) { is_expected.to render_template(:page_404) }
    end
  end

  describe 'DELETE #destroy' do
    let!(:account) { create :account, user: user, bank: 'VCB', name: 'Dummy' }

    context 'when account not found' do
      subject { patch :destroy, params: { id: account.id + 1 } }

      its(:code) { is_expected.to eq '404' }
      its(:body) { is_expected.to render_template(:page_404) }
    end

    context 'when destroy success account' do
      subject { patch :destroy, params: { id: account.id } }

      it { expect { subject }.to change(Account, :count).by(-1) }

      it do
        is_expected
        expect(response.code).to eq '302'
        expect(subject).to redirect_to accounts_path
      end
    end
  end
end
