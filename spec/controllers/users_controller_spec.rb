require 'spec_helper'

describe UsersController do

  render_views

  describe "GET 'new'" do

    it "should be successful" do
      get 'new'
      response.should be_success
    end

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

    it "should show the user's microposts" do
        mp1 = Factory(:micropost, :user => @user, :content => "Foo bar", :created_at => 2.days.ago)
        mp2 = Factory(:micropost, :user => @user, :content => "Baz quux", :created_at => 11.hours.ago)
        get :show, :id => @user
        response.should have_selector("span.content", :content => mp1.content)
        response.should have_selector("span.content", :content => mp2.content)
    end

  end

  describe "POST 'create'" do

    describe "failure" do

      before(:each) do
          @attr = { :name => "", :email => "", :password => "",
                    :password_confirmation => "" }
      end

      it "should not create a user" do
          lambda do
              post :create, :user => @attr
          end.should_not change(User, :count)
      end

      it "should have the right title" do
          post :create, :user => @attr
          response.should have_selector("title", :content => "Sign up")
      end

      it "should render the 'new' page" do
          post :create, :user => @attr
          response.should render_template('new')
      end
    end

    describe "success" do

      before(:each) do
          @attr = { :name => "new user", :email => "new@user.com", :password => "abcdef",
                    :password_confirmation => "abcdef" }
      end

      it "should create a user" do
          lambda do
              post :create, :user => @attr
          end.should change(User, :count).by(1)
      end

      it "should redirect to the 'user' page" do
          post :create, :user => @attr
          response.should redirect_to(user_path(assigns[:user]))
          flash[:success] =~ /elcome to the Sample/i
      end

      it "newly created users should be automatically signed in" do
          lambda do
              post :create, :user => @attr
          end.should change(User, :count).by(1)
          controller.signed_in?.should be_true
      end

    end
  end

  # Testing editing a user

  describe "GET 'edit'" do

     describe 'failure' do

        before(:each) do
          @user = User.create!(:name => "Malcolm", :email => "email@example.com", :password => "password", :password_confirmation => "password")
          User.stub!(:find, @user.id).and_return(@user)
          User.stub!(:find_by_email, @user.email).and_return(@user)
          controller.sign_in(@user)
        end
  
        it "should return the correct page successfuly" do
            get :edit, :id => @user 
            response.should be_successful
        end
  
        it "should have the correct page title" do
            get :edit, :id => @user
            response.should have_selector("title", :content => "Edit User")
        end
  
        it "should have a link to change the gravatar" do
            get :edit, :id => @user
            gravatar_url = "http://gravatar.com/emails"
            response.should have_selector("a", :href => gravatar_url, :content => "Change")
        end
    end

    describe 'success' do
      
      before(:each) do
        @user = User.create!(:name => "Malcolm", :email => "email@example.com", :password => "password", :password_confirmation => "password")
        User.stub!(:find, @user.id).and_return(@user)
        User.stub!(:find_by_email, @user.email).and_return(@user)
        controller.sign_in(@user)
        @update_values = {:name => "New name", :email => "NewEmail@email.com", :password => "changed", :password_confirmation => "changed"}
      end

      it "should link back to the profile form" do
        put :update, :id => @user, :user => @update_values        
        response.should redirect_to(user_path(@user))
      end

      it "should show a success flash" do
        put :update, :id => @user, :user => @update_values        
        flash[:success].should =~ /success/i

      end

      it "should successfully update the user details" do
        put :update, :id => @user, :user => @update_values        
        @user.reload
        @user.name.should == @update_values[:name] 
      end

    end

    describe 'security testing' do

        before(:each) do
          @user = User.create!(:name => "Malcolm", :email => "email@example.com", :password => "password", :password_confirmation => "password")
          @update_values = {:name => "New name", :email => "NewEmail@email.com", :password => "changed", :password_confirmation => "changed"}
        end

        it "should redirect to signin page if not signed in on edit" do
            get :edit, :id => @user
            response.should redirect_to(signin_path)
        end

        it "should redirect to signin page if not signed in on update" do
            put :update, :id => @user, :user => @update_values
            response.should redirect_to(signin_path)
        end
    end

    describe 'wrong user edit attempts' do

        before(:each) do
          @wrong_user = User.create!(:name => "UserX", :email => "userX@example.com", :password => "password", :password_confirmation => "password")
          @user = User.create!(:name => "Malcolm", :email => "email@example.com", :password => "password", :password_confirmation => "password")
          @update_values = {:name => "New name", :email => "NewEmail@email.com", :password => "changed", :password_confirmation => "changed"}
        end

        it "should not be possible for User X to edit Malcolm" do
            controller.sign_in(@wrong_user)
            get :edit, :id => @user
            response.should redirect_to(root_path)
        end

        it "should not be possible for User X to update Malcolm" do
            controller.sign_in(@wrong_user)
            put :update, :id => @user, :user => @update_values

            response.should redirect_to(root_path)
        end
    end

    describe "GET 'index'" do

        describe " for users not signed in" do

            it "should redirect to sign in" do
                get :index

                response.should redirect_to(signin_path)
                flash[:notice].should =~ /sign in/i
            end
        end

        describe "for users signed in" do

            before(:each) do
              @user1 = User.create!(:name => "1", :email => "email1@example.com", :password => "password1", :password_confirmation => "password1")
              @user2 = User.create!(:name => "2", :email => "email2@example.com", :password => "password2", :password_confirmation => "password2")
              @user3 = User.create!(:name => "3", :email => "email3@example.com", :password => "password3", :password_confirmation => "password3")
              @user4 = User.create!(:name => "4", :email => "email4@example.com", :password => "password4", :password_confirmation => "password4")
              User.stub!(:find, @user1.id).and_return(@user1)
              User.stub!(:all).and_return([@user1, @user2, @user3, @user4])
              controller.sign_in(@user1)
            end

            it "should be successful" do
                get :index
                response.should be_successful
            end

            it "should have the correct title" do
                get :index
                response.should have_selector("title", :content => "All Users")
            end

            it "should have an item per user" do
                get :index
                User.all.each do |user| 
                    response.should have_selector("li", :content => user.name)
                end
            end
        end
    end
  end

end
