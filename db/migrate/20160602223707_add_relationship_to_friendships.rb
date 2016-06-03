class AddRelationshipToFriendships < ActiveRecord::Migration
  def change
    add_column :friendships, :relationship, :string
  end
end
