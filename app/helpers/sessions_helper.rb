module SessionsHelper
  def sign_in(user)
    remember_token = User.new_remember_token                                # create a new token
    
    # TODO: create hash with cookie's name
    # cookie.name = :remember_token 
    
    cookies.permanent[:remember_token] = remember_token                     # place the raw token in the browser cookies
    # equivalent to cookies[:remember_token] = { value: remember_token, expires: 20.years.from_now.utc }
    # Each element in the cookie is itself a hash of two elements, a value and an optional expires date
    user.update_attribute(:remember_token, User.digest(remember_token))     # save the hashed token to the database
    self.current_user = user                                                # set the current user equal to the given user
    
    
    Rails.logger.debug cookies
    
    
  end
  def signed_in?
    !current_user.nil?
  end
  # Ruby's syntax for assignment function
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end
  
  def sign_out
    current_user.update_attribute(:remember_token, User.digest(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end
  
  
  # Ruby's syntax for reading function
  # def current_user
    # @current_user
  # end
  
  # If we did this, we would effectively replicate the functionality of 
  # attr_accessor, which we saw in Section 4.4.5.6 The problem is that it 
  # utterly fails to solve our problem: with the code in Listing 8.21, 
  # the user’s signin status would be forgotten: as soon as the user went to 
  # another page—poof!—the session would end and the user would be automatically
  # signed out. This is due to the stateless nature of HTTP interactions 
  # (Section 8.2.1)—when the user makes a second request, all the variables get 
  # set to their defaults, which for instance variables like @current_user is nil.
  # Hence, when a user accesses another page, even on the same application, 
  # Rails has set @current_user to nil, and the code in Listing 8.21 won’t do 
  # what you want it to do.
  
end
