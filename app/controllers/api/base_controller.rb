# frozen_string_literal: true

class Api::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token

  def unauthorized
    render json: { message: 'Unauthorized' }, status: :unauthorized
  end

  def render_422(error_messages)
    render json: { message: 'Unprocessable Entity', errors: error_messages }, status: :unprocessable_entity
  end
end
