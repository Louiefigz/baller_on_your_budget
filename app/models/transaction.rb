class Transaction < ActiveRecord::Base

  belongs_to :user_id
  belongs_to :lender, :class_name => 'User'
  belongs_to :borrower, :class_name => 'User'
  has_many :notes

end
