class UserSerializer < ActiveModel::Serializer
  has_many :borrowed, serializer: UserTransactionSerializer
  has_many :lent_out, serializer: UserTransactionSerializer
  has_many :friends, serializer:UserFriendshipSerializer

  # 
  # has_many :lenders, serializer: UserDebitSerializer
  # has_many :borrowers, serializer: UserDebitSerializer


  attributes :id, :name, :balance
end
