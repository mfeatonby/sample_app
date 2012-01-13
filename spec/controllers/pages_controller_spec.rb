require 'spec_helper'

describe PagesController do

  # Flag indicates that the views should also be tested, not view the controller
  render_views

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success 
    end
    it "should return the correct title" do
      get 'contact'
      response.should have_selector("title",
                      :content => "Ruby on Rails Tutorial Sample App | Contact")
    end
  end
  
  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success 
    end
    it "should return the correct title" do
      get 'about'
      response.should have_selector("title",
                      :content => "Ruby on Rails Tutorial Sample App | About")
    end
  end
  
  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success 
    end
    it "should return the correct title" do
      get 'help'
      response.should have_selector("title",
                      :content => "Ruby on Rails Tutorial Sample App | Help")
    end
  end

  describe "GET 'home'" do

    describe "when not signed in" do

        before(:each) do
            get :home
        end

        it "should be successful" do
            response.should be_success
        end

        it "should have the right title" do
            response.should have_selector("title",
            :content => "Ruby on Rails Tutorial Sample App | Home")
        end
    end

    describe "when signed in" do

        before(:each) do
            @user = Factory(:user)
            controller.sign_in(@user)
            other_user = Factory(:user, :email => Factory.next(:email))
            other_user.follow!(@user)
        end

        it "should have the right follower/following counts" do
            get :home
            response.should have_selector("a", :href => following_user_path(@user),
                                                                    :content => "0 following")
            response.should have_selector("a", :href => followers_user_path(@user),
                                                                    :content => "1 follower")
        end
    end
  end
end
