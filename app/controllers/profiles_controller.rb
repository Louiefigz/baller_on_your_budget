class ProfilesController < ApplicationController
  before_action :logged_in?
  def home
    @users = User.all
  end
end
