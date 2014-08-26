class User < ActiveRecord::Base
  before_save do
    self.email = email.downcase!
    my_logger.info("Creating user with name #{self.name}")
    
  end
  
  # validations
  # http://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html
  
  validates :name, presence: true, length: { maximum: 50 }
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  has_secure_password # presence validations for the password and its confirmation are automatically added by has_secure_password
  validates :password, length: { minimum: 6 }
  
  
  
  private
  
  # http://stackoverflow.com/questions/337739/how-to-log-something-in-rails-in-an-independent-log-file
  def my_logger
    @@my_logger ||= Logger.new("#{Rails.root}/log/user_model.log")
    
    # http://api.rubyonrails.org/files/activerecord/README_rdoc.html
    # Logging support for Log4r and Logger.
    # ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
    # ActiveRecord::Base.logger = Log4r::Logger.new('Application Log')
  end

  # has_secure_password: we need to add password and password_confirmation attributes, require the presence of 
  # the password, require that they match, and add an authenticate method to compare a hashed password to the
  # password_digest to authenticate users. This is the only nontrivial step, and in the latest version of Rails
  # all these features come for free with one method, has_secure_password
  
  # https://github.com/rails/rails/blob/master/activemodel/lib/active_model/secure_password.rb
  # http://api.rubyonrails.org/v4.0.0/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_confirmation_of
end
