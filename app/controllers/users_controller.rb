class UsersController < ApplicationController
  before_action :logged_in?
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :edit_balance, :update_balance, :friend_relationship]
  after_filter :flash_notice

  def flash_notice

    if !@user.flash_notice.blank?
          flash[:notice] = @user.flash_notice

       end
  end

@@email = 22

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def index
    @users = User.all

    respond_to do |f|
      f.html { render :index }
      f.json { render json: @users }
    end
  end

  def new
  end

  def create

  end

  def edit
  end

  def edit_balance

  end

  def update_balance

    @user.update(balance: @user.add_money(params[:balance].to_i))
    redirect_to user_path(@user)
  end

  def add_friends
    @relationships = Relationship.all
    @user = current_user
  end

  def update_friends

  end

  def friend_relationship
    @relationships = Relationship.all
    @relationship = Relationship.new
  end

  def show
    @transaction = Transaction.new
    @friends = @user.friends
    @user.return_json

    respond_to do |f|
      f.html { render :show }
      f.json { render json: [@user.return_json] }
    end
  end

  def update

  end


# This controller route just manipulates the data from the Add_friend form since it is extensive.
# It is used as a POST request.
  def update_relationship

    # The following 4 local variables are to account for creating a false validation of a new user
    # currently Devise gem does not create a new user without valid email and password.
    # the numbers and letters are randomly generated to create the email. This means that we are not able to Access
    # the users, we are only able to create them here.

    @user = User.find(params[:id])
    # @user.update(user_params)
    user_name = params[:user][:users][:name]
    user_rel_params = rel_params
    @user.parse_add_form_data(user_params, user_name, rel_params, drop_params, amount_params, current_user, friend_params, user_rel_params)



    # The User params are updating the friend_ids collection.  Updating the Users current friends.
    # the method below handles creating a new User object if the current user is creating a new friend and
    #adding them to their friends list. Again, Devise requires an email and password that we are falsely generating here.
    # @user.update_friends(user_name, e)
    # @user.creating_relationship_transaction_friend(user_name, user_rel_params, drop_params, amount_params, current_user )
    # @user.create_attributes_with_existing_friends(drop_params, rel_params, friend_params, user_params, current_user, amount_params)
    if !@user.flash_notice.blank?
      redirect_to (:back)
    else
      flash[:message] = "Added Friends Successfully"
      redirect_to root_path
    end
  end





private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:friend_ids=>[], users_attributes: [:name])
  end
# @user.update(name:"Avidor")
# @user.name = "Avidor"

# @user.update(friends_attributes:{friend_ids:[1,2,3,4,5]})
# @user.friends_attributes = {friend_ids:[1,2,3,4,5]}

  def drop_params
    params.require(:description).permit(:relationship_id)
  end

  def friend_params
    params.require(:user)[:relationships].permit(:friend_id, :user_id)
  end
  def rel_params
    params.require(:user)[:relationships].permit(:description)
  end
  def amount_params
    params.require(:user)[:transactions].permit(:amount)[:amount]
  end

end
