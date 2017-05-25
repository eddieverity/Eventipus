class UsersController < ApplicationController
  skip_before_action :require_login, only: [:register, :login, :log_reg]
  def log_reg

  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update user_params
      redirect_to '/'
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to :back
    end
  end

  def register
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      session[:user_name] = @user.name
      redirect_to '/'
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to :back
    end

  end

  def login
    @user = User.find_by('email = ?', params[:user][:email])
    puts @user

    if @user && @user.authenticate(params[:user][:password])
      session[:user_name] = @user.name
      session[:user_id] = @user.id
      redirect_to '/'
    else

      #flash[:errors] = @user.errors.full_messages
      flash[:errors] = ['invalid stuff']
      redirect_to :back
    end

  end

  def logout
    reset_session
    redirect_to '/'
  end


private
  def user_params
    params.require(:user).permit(:email,:name,:location,:state,:password,:password_confirmation)
  end
end
