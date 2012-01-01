require 'spec_helper'

describe UserController do

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

end
