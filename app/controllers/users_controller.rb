class UsersController < ApplicationController
    protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token, only: :create
  
    def create
      user = User.find_or_initialize_by(email: user_params[:email])
      user.assign_attributes(user_params)
  
      # パスワードが空の場合に自動で生成（Googleログインのみの場合）
      user.password = Devise.friendly_token[0, 20] if user.password.blank? && user.provider.present?
  
      if user.save
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
  