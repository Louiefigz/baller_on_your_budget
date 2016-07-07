class UsersController < ApplicationController
  before_action :logged_in?
  before_action :authenticate_user!
  before_action :set_user, only: [:show,  :edit, :edit_balance, :update_balance, :friend_relationship, :update_friends, :post_update_friends]
  after_filter :flash_notice, only:[:parse_add_friend_form_data, :show, :add_friends]

  def flash_notice
    if !@user.flash_notice.blank?
          flash[:notice] = @user.flash_notice
       end
  end



  # def self.new_with_session(params, session)
  #   super.tap do |user|
  #     if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
  #       user.email = data["email"] if user.email.blank?
  #     end
  #   end
  # end

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
  
    @minus_current_friends = User.where.not(id: current_user.friend_ids) & User.where.not(id: current_user.id)
  end

  def update_friends
    @minus_current_friends = User.where(id: current_user.friend_ids)
  end

  def post_update_friends
    @user.update(update_friends_params)
    redirect_to root_path(@user)
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
  def parse_add_friend_form_data

    @user = User.find(params[:id])
    @user.update(user_params)
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
    params.require(:user).permit(:add_friend_ids=>[:relationship_type=>[:description, :drop_down], :friend_ids=>[], :transactions=>[:amount]])
  end

  def update_friends_params
    params.require(:user).permit(:friend_ids=>[])
  end

end
