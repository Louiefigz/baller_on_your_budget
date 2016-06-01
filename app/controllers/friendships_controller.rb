class FriendshipsController < ApplicationController
  def new
    @friendship = Friendship.new
  end

  def create
    friendship = Friendship.create(friend_params)
  end

  def index
    @friends = Friendship.all
    amounts_due = []
    @friends.each do |f|
      amounts_due << current_user.total_amount_due(current_user, f)
    end
    render json: [ @friends, amounts_due ]
  end

  def show
    @user = User.find(params[:user_id])
      @friends = @user.friends.find(params[:id])
  end

private

  def friend_params
    params.require(:friendship).permit(:user_id, :friendship_ids=> [])

  end

end
