class UsersController < ApplicationController
  before_action :logged_in?
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :edit_balance, :update_balance, :friend_relationship]

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
    binding.pry
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




    number = Random.rand(10000000)
    letters = [*('A'..'Z')].sample(8).join
    user_name = params[:user][:users][:name]
    e = "#{number}#{letters}@gmail.com"




    @user = User.find(params[:id])
    @user.update(user_params)
    @user.update_friends(user_name, e)

user_rel_params = rel_params
@user.creating_relationship_transaction_friend(user_name, user_rel_params, drop_params, amount_params, current_user )

@user.create_attributes_with_existing_friends(drop_params, rel_params, friend_params, user_params, current_user)

binding.pry

# amount  = amount_params
# lender_id = current_user.id
# borrower_id = friend_id

    flash[:message] = "Added Friends Successfully"

    redirect_to root_path
  end





private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:friends_attributes => [:friend_ids=>[]], users_attributes: [:name])
  end

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
