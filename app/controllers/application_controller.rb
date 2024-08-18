class ApplicationController < ActionController::API
    include ActionController::RequestForgeryProtection
  
    def csrf_token
      render json: { csrf_token: form_authenticity_token }
    end
  
    protected
  
    def verified_request?
      super || valid_authenticity_token?(session, request.headers['X-CSRF-Token'])
    end
  end