class UserSerializer < ActiveModel::Serializer
  has_many :borrowed, serializer: UserTransactionSerializer
  has_many :lent_out, serializer: UserTransactionSerializer
  has_many :friends, serializer:UserFriendshipSerializer

  attributes :id, :name, :balance
end
