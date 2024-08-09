class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    Rails.logger.info "OmniAuth callback received for Google"
    
    auth = request.env['omniauth.auth']
    Rails.logger.info "Auth info: #{auth.inspect}"

    @user = User.from_omniauth(auth)

    if @user.persisted?
      Rails.logger.info "User persisted: #{@user.inspect}"
      sign_in @user
      render json: { success: true, user: @user }, status: :ok
    else
      Rails.logger.error "User not persisted: #{@user.errors.full_messages.join(', ')}"
      render json: { success: false, errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  rescue => e
    Rails.logger.error "Error in google_oauth2 callback: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    render json: { success: false, error: "認証中にエラーが発生しました。" }, status: :internal_server_error
  end
end