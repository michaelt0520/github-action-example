# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'associations' do
    it { should belong_to(:account) }
  end

  describe 'validates' do
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:transaction_type) }
    it { should enumerize(:transaction_type).in(:withdraw, :deposit) }
  end
end
