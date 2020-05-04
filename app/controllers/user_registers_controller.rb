# frozen_string_literal: true

class UserRegistersController < Devise::RegistrationsController
  def create
    user = User.new(user_params)

    if user.valid? && user.save
      sign_in(user)
      redirect_to root_path
    else
      flash.now[:alert] = 'Something wrong!. Try again'
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :display_name, :password, :password_confirmation)
  end
end
