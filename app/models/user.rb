class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :transactions
  has_many :credits, :foreign_key => 'borrower_id', :class_name => 'Transaction'
  has_many :debits, :foreign_key => 'lender_id', :class_name => 'Transaction'
  has_many :notes, through: :transactions
end
