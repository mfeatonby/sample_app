class SessionsController < ApplicationController

  def new 
      @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:email] , params[:session][:password])
    if user.nil?
      @title = "Sign in"
      flash.now[:error] = "Invalid user id or password."
      render :new
    else
      sign_in user
      redirect_to current_user 
    end
  end

  def destroy
    if signed_in?
        sign_out
    end
    redirect_to root_path
  end

end
