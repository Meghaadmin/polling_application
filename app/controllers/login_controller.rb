class LoginController < ApplicationController
  skip_before_action :require_login,:only => [:login,:logged_in,:register]

  def login
    @user = User.new()
  end

  def logged_in
    @user = User.where(:password =>params[:user][:password],:email_id=>params[:user][:email_id]).first
    if @user.nil?
      respond_to do |format|
      format.html { redirect_to root_path, notice: 'Invalid username/password.' }
      end
    else
    session[:current_user] = @user.id
    session[:user_type]    = @user.user_type
    if $is_admin.eql?@user.user_type
     redirect_to candidates_path
    elsif $is_selector.eql?  @user.user_type
      redirect_to candidates_path
    elsif $is_voter.eql?  @user.user_type
      redirect_to voter_candidates_path
    end
    end
  end

  def register
    @user = User.new()
    respond_to do |format|
      format.html {render 'register'}
    end
  end

  def log_out
    session[:current_user] = nil
    session.delete(:current_user)
    respond_to do |format|
      format.js {render 'log_out'}
      format.html {redirect_to root_url}
    end
  end

end
