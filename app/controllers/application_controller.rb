# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordNotUnique, with: :conflict

  def not_found
    respond_to do |f|
      f.html { render 'pages/page_404', layout: 'application', status: :not_found }
      f.json { render json: { message: 'Not Found' },          status: :not_found }
    end
  end

  def conflict
    render json: { message: 'Conflict' }, status: :conflict
  end
end
