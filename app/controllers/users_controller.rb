class UsersController < ApplicationController
  skip_before_action :require_login,:only => [:create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end


  # Two types of user will be created, Selector and Voter .If the user type is selector, then selector has to wait for admin's approval..
  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if params[:user][:user_type].nil?
      flash[:error] = "Please make a selection Voter/Selector"
      redirect_to register_login_index_path
    else
      if $is_selector.eql? @user.user_type
        notice = 'Your request to be a selector has been sent to admin for approval.'
      else
        password = '$' + @user.name + '#'
        @user.update_attribute(:password,password)
        @user.save
        UserMailer.send_password(@user).deliver
        notice = 'User was successfully created.To login use username and password which has been sent to your email.'
      end
      respond_to do |format|
        if @user.save
          format.html { redirect_to root_path, notice: notice }
        end
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  #Admin will approve the selectors and the mail will send to the selector with password

  def approve_selector
    @user = User.find(params[:id])
    password = 'Water' + @user.name
    @user.update_attributes(:is_approved => 1,:password=>password)
    @user.save
    UserMailer.send_password(@user).deliver
    respond_to do |format|
      if @user.save
        format.html { redirect_to candidates_path, notice: 'Selector has been approved and mail has been send' }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      temp=params.require(:user)
      temp[:is_approved] = 0 if '2'.eql?temp[:user_type]
      temp.permit(:name, :password, :user_type, :email_id, :is_approved)
    end
end
