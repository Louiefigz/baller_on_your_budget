class FriendshipsController < ApplicationController
  def new
    @friendship = Friendship.new
  end

  def create
    friendship = Friendship.create(friend_params)
  end


private

  def friend_params
    params.require(:friendship).permit(:user_id, :friendship_ids=> [])

  end

end
