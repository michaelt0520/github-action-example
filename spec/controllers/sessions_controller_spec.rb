# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET #new' do
    context 'when user login already' do
      let!(:user) { create :user }

      before { authenticate_user(user) }

      subject { get :new }

      it 'redirect to home page' do
        is_expected
        expect(response.code).to eq '302'
        expect(subject).to redirect_to root_path
      end
    end

    context 'when user not signin' do
      subject { get :new }

      its(:code) { is_expected.to eq '200' }
      its(:body) { is_expected.to render_template(:new) }
    end
  end

  describe 'POST #create' do
    let!(:user) { create :user, email: 'congcong@gmail.com', password: 'password', password_confirmation: 'password' }

    context 'when user invalid password' do
      subject { post :create, params: { email: 'congcong@gmail.com', password: 'passpass' } }

      it 'render login page' do
        is_expected
        expect(flash[:alert]).to be_truthy
        expect(response.code).to eq '200'
        expect(subject).to render_template(:new)
      end
    end

    context 'when user login success' do
      subject { post :create, params: { email: 'congcong@gmail.com', password: 'password' } }

      it 'redirect to home page' do
        is_expected
        expect(response.code).to eq '302'
        expect(subject).to redirect_to root_path
      end
    end
  end
end
