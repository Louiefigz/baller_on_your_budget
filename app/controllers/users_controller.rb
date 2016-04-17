class UsersController < ApplicationController
  before_action :logged_in?
  before_action :set_user, only: [:show, :edit, :edit_balance, :update_balance]

  def new
  end

  def create
  end

  def edit
  end

  def edit_balance
  

  end

  def update_balance
    binding.pry
  end

  def update
  end

  def show

  end

  def destroy
  end

private
  def set_user
    @user = User.find(params[:id])
  end

end
