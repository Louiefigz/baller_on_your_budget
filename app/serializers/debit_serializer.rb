# class DebitSerializer < ActiveModel::Serializer
# #   has_one :lender, class_name: "User"
# #   has_one :borrower, class_name: "User"
# #   attributes :id, :borrower_id, :lender_id
#
#
# has_one :lender :class_name => "User", foreign_key: "lender_id"
# has_one :borrower, :class_name => "User", foreign_key: 'borrower_id'
# has_many :transactions, through: :lender
# has_many :transactions, through: :borrower
# attributes :id
# end
