class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy # dependent ensures that a user’s microposts are destroyed along with the user.
  # TODO dependent should de-activate data instead of destroying it
  
  # when the foreign key for a User model object is user_id, Rails infers the association automatically: by default, Rails
  # expects a foreign key of the form <class>_id, where <class> is the lower-case version of the class name.
  # In the present case, although we are still dealing with users, they are now identified with the foreign key follower_id, 
  # so we have to tell that to Rails
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  
  # By default, in a has_many through association Rails looks for a foreign key 
  # corresponding to the singular version of the association; in other words, code like
  # has_many :followeds, through: :relationships
  # would assemble an array using the followed_id in the relationships table. 
  # But, user.followeds is rather awkward; far more natural is to use “followed users” 
  # as a plural of “followed”, and write instead user.followed_users for the array
  # of followed users. Naturally, Rails allows us to override the default, in this case
  # using the :source parameter, which explicitly tells Rails that the source of
  # the followed_users array is the set of followed ids.
  has_many :followed_users, through: :relationships, source: :followed
  
  # Note that we actually have to include the class name for this association
  # because otherwise Rails would look for a ReverseRelationship class, which doesn’t exist
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  
  
  
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
  # TODO [20140601] add salt to the password
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
  
  def feed
    # This is preliminary. See "Following users" for the full implementation.
    # Micropost.where("user_id = ?", id) # is essentially equivalent to writing "microposts"
    Micropost.from_users_followed_by(self)
  end
  
  def following?(other_user)
    relationships.find_by(followed_id: other_user.id) # true: object; false: nil
    # we have omitted the user itself, but it's equivalent to:
    # self.relationships.find_by(followed_id: other_user.id)
    # Whether to include the explicit self is largely a matter of taste.
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id) # new && save or raise exception
    # equivalent to:
    # self.relationships.create!(followed_id: other_user.id)
  end
  
  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end
  
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
