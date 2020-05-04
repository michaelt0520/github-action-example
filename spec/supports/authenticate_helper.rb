# frozen_string_literal: true

module AuthenticateHelper
  def authenticate_user(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end
end
