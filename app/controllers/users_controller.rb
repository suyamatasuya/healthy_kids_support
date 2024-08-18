class UsersController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token, only: [:create, :update]

  def create
    user = User.find_or_initialize_by(email: user_params[:email])
    user.assign_attributes(user_params)

    user.password = Devise.friendly_token[0, 20] if user.password.blank? && user.provider.present?

    if user.save
      render json: { user: user }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    user = User.find_by(uid: params[:id])
    if user
      render json: { user: user }, status: :ok
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: { user: user }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :provider, :uid, :password)
  end
end
