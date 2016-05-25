class UsersController < ApplicationController
  before_action :logged_in?
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :edit_balance, :update_balance]


  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def index
    @users = User.all
    render json: @users
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
    @user = current_user

  end

  def update_friends

  end

  def show
    @transaction = Transaction.new

    @user.return_json

    respond_to do |f|
      f.html { render :show }
      f.json { render json: [@user.return_json] }
    end
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    flash[:message] = "Added Friends Successfully"
    redirect_to root_path
  end

private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:friends_attributes => [:friend_ids=>[]])
  end

end
