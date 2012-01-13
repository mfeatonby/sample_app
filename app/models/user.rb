require 'digest'

class User < ActiveRecord::Base

    #
    # User attributes
    # 
    email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 

    attr_accessor :password

    attr_accessible :name, :email, :password, :password_confirmation

    validates :name, :presence => true,
                     :length => {:maximum => 50 } 
    validates :email, :presence => true,
                      :format => { :with => email_regex },
                      :uniqueness => {:case_sensitive => false } 

    validates :password, :presence => true,
                         :confirmation => true,
                         :length => { :within => 6..40 }

    before_save :encrypt_password

    #
    # Microposts
    #
    has_many :microposts, :dependent => :destroy
  
    #
    # Class methods
    #
    def self.authenticate(email, password)
      user = User.find_by_email(email)
      if user == nil || !user.has_password?(password)
        user = nil
      end
      return user
    end

    def self.authenticate_with_salt(id, cookie_salt)
        user = find_by_id(id)
        (user && user.salt == cookie_salt) ? user : nil
    end

    public
    # Returns true if this user has a password which matches the password provided.
    def has_password?(a_password)
        self.encrypted_password == encrypt(a_password)
    end

    # Returns the micropost feed for this user
    def feed
        Micropost.where("user_id = ?", id) 
    end

    private

    #Active record callback method for encrypting the password on save.
    def encrypt_password
      self.salt = make_salt unless has_password?(password)
      self.encrypted_password = encrypt(password)
    end

    def make_salt
      Time.now.utc.to_s
    end

    #Password encryption routine.
    def encrypt(clear_text_password)
      Digest::SHA2.hexdigest("#{salt}--#{clear_text_password}")
    end

end
