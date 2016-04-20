class Debit < ActiveRecord::Base

  belongs_to :lender, :class_name => "User", foreign_key: "lender_id"
  belongs_to :borrower, :class_name => "User", foreign_key: 'borrower_id'
  has_many :transactions, through: :lender
  has_many :transactions, through: :borrower

end
