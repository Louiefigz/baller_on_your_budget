class UserTransactionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :lender, :borrower
end
