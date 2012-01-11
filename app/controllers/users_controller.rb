class UsersController < ApplicationController

  def new
    @title = "Sign Up"
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def index
    @title = "All Users"
    @users = User.all
  end

  def create
    @user = User.new(params[:user])
    if @user.save
        flash[:success] = "Welcome to the Sample Application!"
        sign_in(@user)
        redirect_to @user 
    else
        @title  = "Sign up"
        render 'new'
    end
  end

end
