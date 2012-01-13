class MicropostsController < ApplicationController

  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :can_destroy, :only => [:destroy]

  def create
      @micropost = current_user.microposts.build(params[:micropost])
      if @micropost.save
          flash[:success] = "New post created!"
          redirect_to root_path
      else
          @feed_items = current_user.feed.paginate(:page => params[:page]) 
          render 'pages/home'
      end
  end

  def can_destroy
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_path if @micropost.nil?
  end

  def destroy
      post = Micropost.find(params[:id])
      post.destroy
      flash[:success] = "Post deleted !"
      redirect_to root_path
  end

end
