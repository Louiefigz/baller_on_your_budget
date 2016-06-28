class RelationshipsController < ApplicationController
  def new
    @relationship = Relationship.new
    @relationships = Relationship.all
  end

  def create
  new_rel = Relationship.new(relationship_params)
  new_rel.save
    redirect_to root_path
  end


private

  def relationship_params
    params.require(:relationship).permit(:updated_relationship=>[:drop_down, :description, :friend_id, :user_id])
  end
  

end
