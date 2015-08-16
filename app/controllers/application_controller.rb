class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include ApplicationHelper
  helper_method :current_user
  protect_from_forgery with: :exception
  before_action :require_login

  private
  def require_login
    if session[:current_user].nil?
      redirect_to root_url
    end
  end

end
