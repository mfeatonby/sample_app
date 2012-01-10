class UsersController < ApplicationController

  def new
    @title = "Sign Up"
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def index
    @title = "All Users"
    @users = User.all
  end

end
