class UsersController < ApplicationController

  before_filter :authenticate, :except => [:show, :new, :create] 
  before_filter :correct_user, :only => [:update, :edit]
  before_filter :admin_only, :only => [:destroy]

  def admin_only
      redirect_to(root_path) unless current_user.admin?
  end

  def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user) || current_user.admin?
  end

  def new
    @title = "Sign Up"
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
    @microposts = @user.microposts.paginate(:page => params[:page])
  end

  def index
    @title = "All Users"
    @users = User.paginate(:page => params[:page])
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

  def edit
     @user = User.find(params[:id])
     @title = "Edit User"
  end

  def update
     @user = User.find(params[:id])
     if !@user.nil?
        if @user.update_attributes(params[:user])
           flash[:success] = "Details updated successfully"
           redirect_to user_path(@user)
        else
          @title = 'Edit User'
          render :edit
        end
     end
  end

  def destroy 
      @user = User.find(params[:id])
      if current_user?(@user)
          flash[:error] = "You can't delete yourself!"
          redirect_to users_path
      else
          @user.delete
          flash[:success] = "User #{@user.name} deleted !"
          redirect_to users_path
      end
  end

  def followers
    @user = User.find(params[:id])
    @title = "Followers of #{@user.name}"
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  def following
    @user = User.find(params[:id])
    @title = "#{@user.name} follows"
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

end
