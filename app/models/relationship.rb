class Relationship < ActiveRecord::Base
  has_many :friendships

  validates_presence_of :description



  def updated_relationship=(attributes)
    @friend = Friendship.find_or_create_by(user_id: attributes[:user_id], friend_id: attributes[:friend_id])
    if attributes[:description] != ""
      create_type = Relationship.find_or_create_by(description: attributes[:description])
      @friend.update(relationship_id: create_type.id)
    else
      @friend.update(relationship_id: attributes[:drop_down])
    end

  end
end
