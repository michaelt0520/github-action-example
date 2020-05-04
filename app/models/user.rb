# frozen_string_literal: true

class User < ApplicationRecord
  extend Enumerize
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable

  has_many :accounts, dependent: :destroy
  has_many :transactions, through: :accounts

  def created_date
    created_at.strftime('%d %b. %Y')
  end
end
