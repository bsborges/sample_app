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
end
