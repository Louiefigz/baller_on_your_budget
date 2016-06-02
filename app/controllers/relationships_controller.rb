class RelationshipsController < ApplicationController
  def new
    @relationship = Relationship.new
    @relationships = Relationship.all
  end

  def create
    Relationship.create(rel_params)
    redirect_to root_path
  end

private

  def rel_params
    params.require(:relationship).permit(:description)
  end

end
