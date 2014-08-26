class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  has_secure_password # presence validations for the password and its confirmation are automatically added by has_secure_password
  validates :password, length: { minimum: 6 }
  
  # has_secure_password: we need to add password and password_confirmation attributes, require the presence of 
  # the password, require that they match, and add an authenticate method to compare a hashed password to the
  # password_digest to authenticate users. This is the only nontrivial step, and in the latest version of Rails
  # all these features come for free with one method, has_secure_password
  
  # https://github.com/rails/rails/blob/master/activemodel/lib/active_model/secure_password.rb
  # http://api.rubyonrails.org/v4.0.0/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_confirmation_of
end
