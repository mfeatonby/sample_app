class UsersController < ApplicationController

  def new
    @title = "Sign Up"
  end

  def show
    @title = "User #{params[:id]}"
    @user = User.find(params[:id])
  end

  def index
    @title = "All Users"
    @users = User.all
  end

end
