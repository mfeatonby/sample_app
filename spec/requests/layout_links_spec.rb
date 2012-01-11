require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home page at '/'" do
      get '/'
      response.should have_selector('title', :content => "Home")
  end

  it "should have a Contact page at '/contact'" do
      get '/contact'
      response.should have_selector('title', :content => "Contact")
  end

  it "should have an About page at '/about'" do
      get '/about'
      response.should have_selector('title', :content => "About")
  end
                                      
  it "should have a Help page at '/help'" do
      get '/help'
      response.should have_selector('title', :content => "Help")
  end
  
  it "should have a Signup page at '/signup'" do
      get '/signup'
      response.should have_selector('title', :content => "Sign Up")
  end

  it "should be possible to navigate through the footer links" do
      visit root_path
      click_link "About"
      response.should have_selector('title', :content => "About")
      click_link "Contact"
      response.should have_selector('title', :content => "Contact")
  end

  it "should be possible to navigate through the header links" do
      visit root_path
      click_link "Home" 
      response.should have_selector('title', :content => "Home")
      click_link "Help"
  end

  it "should be possible to navigate to the sign up page from the home page" do
      visit root_path
      click_link "Sign up now!"
      response.should have_selector('title', :content => "Sign Up")
  end

  it "should have a profile link if signed in" do
     user = User.create!(:name => "somename", :email => "someemail@address.org", :password => "password", :password_confirmation => "password")
     User.stub!(:find, user.id).and_return(user)
     User.stub!(:find_by_email, user.email).and_return(user)

     visit signin_path 

     fill_in :email , :with => user.email
     fill_in :password, :with => user.password
     click_button

     controller.should be_signed_in
     controller.current_user.should == user

     click_link "Sign Out"

     controller.signed_in?.should be_false
     controller.current_user.should be_nil 

  end

end
