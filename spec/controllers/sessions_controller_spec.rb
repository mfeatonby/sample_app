require 'spec_helper'

describe SessionsController do

  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the correct title" do
      get 'new'
      response.should have_selector("title", :content => "Sign in")
    end

  end

  describe "POST 'create'" do

    before (:each) do
      @attr = {:email => "example@example.com", :password => "invalid"}
    end

    it "should show an error on an incorrect sign in" do
      post :create, :session => @attr
      flash.now[:error].should =~ /Invalid/i
    end

    it "should render the correct template" do
      post :create, :session => @attr
      response.should render_template('new') 
    end

    it "should have the correct title" do
      post :create, :session => @attr
      response.should have_selector("title", :content => "Sign in")
    end
  end

  describe "with valid sign on details" do

    before (:each) do
      @user = User.create(:name => "test1", :email => "test1@email.com", :password => "password", :password_confirmation => "password")
      @user.stub!(:find, @user.id).and_return(@user)
      @user.stub!(:find_by_email, @user.email).and_return(@user)

      @attr = {:email => @user.email, :password => @user.password}
    end

    it "should sign the user in" do
      post :create, :session => @attr
      # Something else goes here.
    end

    it "should redirect to the user page correctly" do
      post :create, :session => @attr
      response.should redirect_to(user_path(@user))
    end
  end

  describe "test the coookie integration" do

    before (:each) do
      @user = User.create(:name => "test1", :email => "test1@email.com", :password => "password", :password_confirmation => "password")
      @user.stub!(:find, @user.id).and_return(@user)
      @user.stub!(:find_by_email, @user.email).and_return(@user)

      @attr = {:email => @user.email, :password => @user.password}
    end

    it "should redirect to the user page correctly" do
      post :create, :session => @attr
      controller.current_user.should == @user
      controller.should be_signed_in
      controller.signed_in?.should be_true
    end
  end

  describe "Test signing out" do

    before (:each) do
      @user = User.create(:name => "test1", :email => "test1@email.com", :password => "password", :password_confirmation => "password")
      @user.stub!(:find, @user.id).and_return(@user)
      @user.stub!(:find_by_email, @user.email).and_return(@user)
    end

    it "should be possible to sign out" do
        controller.sign_in(@user)
        controller.signed_in?.should be_true
        controller.current_user.should == @user

        delete :destroy

        controller.signed_in?.should be_false
        controller.current_user.should be_nil

        response.should redirect_to(root_path)
    end

  end

end
