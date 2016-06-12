class AuthorizationError < StandardError; end

class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  rescue_from AuthorizationError, with: :unauthorized

  def requires_user_may(permission, object)
    return if current_user.may?(permission, object)
    fail AuthorizationError
  end

  private

  def unauthorized
    head :forbidden
  end
end
