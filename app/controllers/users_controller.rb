class UsersController < ApplicationController
  
  
  # authentication allows us to identify users of our site, and 
  # authorization lets us control what they can do (resources they can access)
  
  
  # authorization access
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  # By default, before filters apply to every action in a controller, so here we
  # restrict the filter to act only on the :edit and :update actions by passing
  # the appropriate :only options hash.
  
  # together with :success and :error, the :notice key completes our triumvirate of flash styles
  
  
  # TODO [20140101] TESTE
  
  def index
    # TODO paginate - give option to paginate with 10, 20, 30, 50
    @users = User.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    #@user = User.find_by(id: params[:id])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    # @user = User.find(params[:id]) # before filter provides the correct_user
  end
  
  def update
    # @user = User.find(params[:id]) # before filter provides the correct_user
    if @user.update_attributes(user_params)
      # Handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    #redirect_to users_url
    redirect_to users_path # previous version
  end
  
  private

    # Uses strong parameters to prevent mass assignment vulnerability
    # Strong parameters
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # Before filters

    def signed_in_user
      store_location
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
