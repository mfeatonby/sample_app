require 'spec_helper'

describe UsersController do

  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    #it "should have a valid title!" do
    #  get 'new'
    #  response.should have_selector('title', 
    #    :content => 'Ruby on Rails Tutorial Sample App | Sign Up')
    #end
  end

  describe "GET 'show'" do

    before(:each) do
      @user = User.create!(:name => "Malcolm", :email => "email@example.com", :password => "password", :password_confirmation => "password")
      User.stub!(:find, @user.id).and_return(@user)
    end

    it "should be successful" do
      get :show, :id => @user 
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user 
      assigns(:user).should == @user
    end

    it "should have the user name as the title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should have the user name as the header" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have the correct gravatar" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar") 
    end

  end

end
