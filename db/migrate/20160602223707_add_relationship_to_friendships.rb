class AddRelationshipToFriendships < ActiveRecord::Migration
  def change
    add_column :users, :relationship, :string
  end
end
