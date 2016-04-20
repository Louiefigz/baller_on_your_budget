class UsersController < ApplicationController
  before_action :logged_in?
  before_action :set_user, only: [:show, :edit, :edit_balance, :update_balance]


  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
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

  def update
  end

  def show
    @transaction = Transaction.new
  end

  def destroy
  end

private
  def set_user
    @user = User.find(params[:id])
  end

end
