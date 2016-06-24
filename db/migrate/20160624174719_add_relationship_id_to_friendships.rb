class AddRelationshipIdToFriendships < ActiveRecord::Migration
  def change
    add_column :friendships, :relationship_id, :integer
  end
end
