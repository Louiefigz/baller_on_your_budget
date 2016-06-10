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

    if drop_params[:relationship_id].to_i != 0
      word = drop_params[:relationship_id].to_i
    else
      word = 1
    end

    new_user_info = User.last

    new_word = Relationship.find(word)
    new_friend_relationship = Friendship.find_by(user_id: current_user.id, friend_id: new_user_info.id)
    new_friend_relationship.update(relationship: new_word.description)

    if amount_params != ""
      @transaction = Transaction.new(lender_id: current_user.id, borrower_id: new_user_info.id, amount: amount_params)

      if @transaction.save
      else
        flash[:message] = @transaction.errors.full_messages[0]
        redirect_to user_friendship_path(current_user.id, params[:transaction][:lender_id])
      end
    end
  else

    if drop_params[:relationship_id].to_i != 0
      word = drop_params[:relationship_id].to_i
    else
      word = 1
    end

    new_word =Relationship.find_or_create_by(description: rel_params[:description])
    new_friend_rel = Friendship.find_by(user_id: current_user.id, friend_id: User.last.id)
    new_friend_rel.update(relationship: new_word.description)

    if amount_params != ""
      @transaction = Transaction.new(lender_id: current_user.id, borrower_id: User.last.id, amount: amount_params)

      if @transaction.save
      else
        flash[:message] = @transaction.errors.full_messages[0]
        redirect_to user_friendship_path(current_user.id, params[:transaction][:lender_id])
      end
    end




  end

  if drop_params[:relationship_id].to_i != 0
    word = drop_params[:relationship_id].to_i
  else
    word = 1
  end


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

            if amount_params != ""
              @transaction = Transaction.new(lender_id: current_user.id, borrower_id: friend.to_i, amount: amount_params)

              if @transaction.save
              else
                flash[:message] = @transaction.errors.full_messages[0]
                redirect_to user_friendship_path(current_user.id, params[:transaction][:lender_id])
              end
            end


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


              if amount_params != ""
                @transaction = Transaction.new(lender_id: current_user.id, borrower_id: existing_friend.id, amount: amount_params)
                if @transaction.save
                  else
                    flash[:message] = @transaction.errors.full_messages[0]
                    redirect_to user_friendship_path(current_user.id, params[:transaction][:lender_id])
                end
              end
          end

        end
      end
    end
binding.pry

# amount  = amount_params
# lender_id = current_user.id
# borrower_id = friend_id

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
  def amount_params
    params.require(:user)[:transactions].permit(:amount)[:amount]
  end

end
