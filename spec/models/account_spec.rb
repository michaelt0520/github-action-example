# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:transactions).dependent(:destroy) }
  end

  describe 'validates' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:bank) }
    it { should enumerize(:bank).in('VCB', 'ACB', 'VIB') }
  end
end
