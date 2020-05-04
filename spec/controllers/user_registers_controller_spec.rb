# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserRegistersController, type: :controller do
  describe 'POST #create' do
    context 'when params user is invalid' do
      subject { page }
    end

    context 'when params user is valid' do
    end

    context 'when user has exists' do
    end
  end
end
