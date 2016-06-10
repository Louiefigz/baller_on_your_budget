class RelationshipsController < ApplicationController
  def new
    @relationship = Relationship.new
    @relationships = Relationship.all
  end

  def create
  
    word = drop_params[:relationship_id].to_i

    if rel_params[:description] == ""
      friend = Friendship.find_by(friend_params)

      new_word = Relationship.find(word)
      friend.update(relationship: new_word.description)
    else
      Relationship.find_or_create_by(rel_params)
      friend = Friendship.find_by(friend_params)
      friend.update(relationship: rel_params[:description])
    end

    redirect_to root_path
  end


private

  def rel_params
    params.require(:relationship).permit(:description)
  end

  def friend_params
    params.require(:relationship).permit(:user_id, :friend_id)
  end

  def drop_params
    params.require(:description).permit(:relationship_id)
  end

end
