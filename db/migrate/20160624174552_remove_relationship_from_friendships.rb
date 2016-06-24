class RemoveRelationshipFromFriendships < ActiveRecord::Migration
  def change
    remove_column :friendships, :relationship, :string
  end
end
