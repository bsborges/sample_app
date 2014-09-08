class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') } # Ordering the microposts with default_scope.
  # As of Rails 4.0, all scopes take an anonymous function that returns the criteria 
  # desired for the scope, mainly so that the scope need not be evaluated immediately,
  # but rather can be loaded later on an as-needed basis (so-called lazy evaluation).
  # The syntax for this kind of object, called a Proc (procedure) or lambda, is the
  # It takes in a block and then evaluates it when called with the call method.
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  
  
  # In the unlikely event that finding the count is still a bottleneck in 
  # your application, you can make it even faster with a counter cache.
  # url: http://railscasts.com/episodes/23-counter-cache-column
  # eg, user.microposts.count
  
  
  
  
  
  # At this point, you might guess that code like
  # Micropost.from_users_followed_by(user)
  # will involve a class method in the Micropost class
  
  # motivation: The purpose of a feed is to pull out the microposts whose user ids 
  # correspond to the users being followed by the current user (and the current user itself)
  
  # SELECT * FROM microposts
  # WHERE user_id IN (<list of ids>) OR user_id = <user id>
  
  # Here we’ve used the Rails convention of user instead of user.id in the condition; Rails automatically uses the id.
  
  # Returns microposts from the users being followed by the given user.
  def self.from_users_followed_by(user) # class method
    # equivalents:
    # User.first.followed_users.map { |i| i.to_s }
    # User.first.followed_users.map(&:id)
    # User.first.followed_user_ids
    
    # In particular, we can replace the Ruby code
    # followed_user_ids = user.followed_user_ids
    # with the SQL snippet
    followed_user_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    # where("user_id IN (?) OR user_id = ?", followed_user_ids, user) # what if the user follows 5000 other users?
    
    # escaped: It actually works either way, but logically it makes more sense to interpolate in this context
    # where("user_id IN (:followed_user_ids) OR user_id = :user_id",
    #       followed_user_ids: followed_user_ids, user_id: user)
          
    # interpolated
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
          
          
    # This code contains an SQL subselect, and internally the entire select for user 1 would look something like this:
    # SELECT * FROM microposts
    # WHERE user_id IN (SELECT followed_id FROM relationships
    #              WHERE follower_id = 1)
    #  OR user_id = 1
    
    # This subselect arranges for all the set logic to be pushed into the database, which is more efficient
    
    # Of course, even the subselect won’t scale forever. For bigger sites, you would probably 
    # need to generate the feed asynchronously using a background job, but such scaling 
    # subtleties are beyond the scope of this tutorial.
  end
end
