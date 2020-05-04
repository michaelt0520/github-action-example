# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[create new]

  def new
    redirect_to root_path if current_user
  end

  def create
    user = User.find_by(email: params[:email])

    raise ActiveRecord::RecordNotFound unless user

    if user.valid_password?(params[:password])
      sign_in(user)
      redirect_to root_path
    else
      flash.now[:alert] = 'Password is incorrect'
      render :new
    end
  rescue ActiveRecord::RecordNotFound
    flash.now[:alert] = 'User does not exist'
    render :new
  end

  def destroy
    sign_out(current_user)
    redirect_to root_path
  end
end
