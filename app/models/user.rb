require 'digest'

class User < ActiveRecord::Base

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

    public
    # Returns true if this user has a password which matches the password provided.
    def has_password?(a_password)
        self.encrypted_password == encrypt(a_password)
    end

    private

    #Active record callback method for encrypting the password on save.
    def encrypt_password
      self.encrypted_password = encrypt(password)
    end

    #Password encryption routine.
    def encrypt(clear_text_password)
      Digest::SHA2.hexdigest(clear_text_password)
    end

end
