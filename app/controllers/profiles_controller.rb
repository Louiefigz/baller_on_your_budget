class ProfilesController < ApplicationController
  before_action :logged_in?
  before_action :authenticate_user!
  def home
    @users = User.all
  end
end
