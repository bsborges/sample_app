class User < ActiveRecord::Base
  before_save do
    self.email = email.downcase
    my_logger.info("Creating user with name #{self.name}")
  end
  before_create :create_remember_token
  
  # add attribute to the model: rails generate migration add_ATTRIBUTE_to_users attribute:type; eg. rails generate migration add_admin_to_users admin:boolean
  
  # validations
  # http://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html
  # http://api.rubyonrails.org/v4.0.0/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_confirmation_of

  validates :name, presence: true, length: { maximum: 50 }
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  
  
  # TODO [20150101] activate user
  # TODO [20150101] block user with 3 failed attempts + send email to reactivate
  
  # TODO [20150101] put salt in the password_digest (fixed size byte code)
  # TODO [20131001] save email and name hashed
  
  has_secure_password # presence validations for the password and its confirmation are automatically added by has_secure_password  
  # has_secure_password: we need to add password and password_confirmation attributes, require the presence of 
  # the password, require that they match, and add an authenticate method to compare a hashed password to the
  # password_digest to authenticate users. This is the only nontrivial step, and in the latest version of Rails
  # all these features come for free with one method, has_secure_password
  
  # https://github.com/rails/rails/blob/master/activemodel/lib/active_model/secure_password.rb
  
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    # SHA1 is less secure than Bcrypt, but in the present case it is more than 
    # sufficient because the token being hashed is already a 16-digit random 
    # string; the SHA1 hexdigest of such a string is essentially uncrackable
    # TODO [20140601] use SHA3 -> https://github.com/phusion/digest-sha3-ruby
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  
  # TODO [20140601] add salt to the password
  
  private
  
    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

    # http://stackoverflow.com/questions/337739/how-to-log-something-in-rails-in-an-independent-log-file
    def my_logger
      @@my_logger ||= Logger.new("#{Rails.root}/log/user_model.log")
    
      # http://api.rubyonrails.org/files/activerecord/README_rdoc.html
      # Logging support for Log4r and Logger.
      # ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
      # ActiveRecord::Base.logger = Log4r::Logger.new('Application Log')
    end

end
