class FriendshipSerializer < ActiveModel::Serializer
  has_one :user
  has_one :friend, class_name: "User"
  
end
