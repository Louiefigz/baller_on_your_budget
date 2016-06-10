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
  if user_name != "" && rel_params[:description] == ""
    new_user_info = User.find_by(name:user_name)
    word = drop_params[:relationship_id].to_i
    new_word = Relationship.find(word)
    new_friend_relationship = Friendship.find_by(user_id: current_user.id, friend_id: new_user_info.id)
    new_friend_relationship.update(relationship: new_word.description)

  end

    word = drop_params[:relationship_id].to_i

      if rel_params[:description] == ""

        if friend_params[:friend_id] != friend_params[:user_id]
          friend = Friendship.find_or_create_by(friend_params)
          new_word = Relationship.find(word)
          friend.update(relationship: new_word.description)
        end
        user_params[:friends_attributes][:friend_ids].each do |friend|
          if friend != ""
            existing_friend = User.find(friend)
            set_relationship = Friendship.find_or_create_by(friend_id: existing_friend.id, user_id: current_user.id)
            new_word = Relationship.find(word)
            set_relationship.update(relationship: new_word.description)
          end


        end
      else
        new_word =Relationship.find_or_create_by(description: rel_params[:description])

        user_params[:friends_attributes][:friend_ids].each do |friend|

          if friend != ""
            existing_friend = User.find(friend)
            if existing_friend.id != current_user.id

              set_relationship = Friendship.find_or_create_by(friend_id: existing_friend.id, user_id: current_user.id)
              set_relationship.update(relationship: new_word.description)
          end

        end
      end
    end


    flash[:message] = "Added Friends Successfully"

    redirect_to root_path
  end

  # def friends
  #   @friends = @user.friends
  # end


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

end
