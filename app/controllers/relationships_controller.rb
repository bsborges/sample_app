class RelationshipsController < ApplicationController
  before_action :signed_in_user

  # the application code uses the same create and destroy actions to respond to 
  # the Ajax requests that it uses to respond to ordinary POST and DELETE HTTP requests.
  # All we need to do is respond to a normal HTTP request with a redirect  and 
  # respond to an Ajax request with JavaScript
  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
  
  # In the case of an Ajax request, Rails automatically calls a JavaScript Embedded Ruby (.js.erb) 
  # file with the same name as the action, i.e., create.js.erb or destroy.js.erb. 
  # As you might guess, the files allow us to mix JavaScript and Embedded Ruby to perform
  # actions on the current page. It is these files that we need to create and edit in order 
  # to update the user profile page upon being followed or unfollowed.
  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
  
  # Inside a JS-ERb file, Rails automatically provides the jQuery JavaScript helpers to manipulate
  # the page using the Document Object Model (DOM). The jQuery library provides a large number of
  # methods for manipulating the DOM
  
  # def destroy
  #   @user = Relationship.find(params[:id]).followed
  #   current_user.unfollow!(@user)
  #   redirect_to @user
  # end

end