class Credit < ActiveRecord::Base

  belongs_to :lender, :class_name => "User"
  belongs_to :borrower, :class_name => "User"
  has_many :transactions, through: :lender
  has_many :transactions, through: :borrower

end
