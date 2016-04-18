class Transaction < ActiveRecord::Base

  belongs_to :user
  belongs_to :lender, :class_name => 'User'#, foreign_key: 'lender_id'
  belongs_to :borrower, :class_name => 'User'#, foreign_key: 'borrower_id'
  has_many :notes

  validates :amount, :numericality => { :only_integer => true, :greater_than => 0 }

end
