class Transaction < ActiveRecord::Base

  belongs_to :user
  belongs_to :lender, :class_name => 'User'#, foreign_key: 'lender_id'
  belongs_to :borrower, :class_name => 'User'#, foreign_key: 'borrower_id'


  validates :amount, :numericality => { :only_integer => true, :greater_than => 0 }

  scope :biggest, -> { order ('amount DESC LIMIT 5') }

  attr_accessor :flash_notice

  validate :error_message_check
  after_create :update_debit_credit


  def error_message_check
    lender = User.find(self.lender_id)
    borrower = User.find(self.borrower_id)

    if self.lending
      if lender.balance - self.amount < 0
        errors.add(:amount, "Transaction could not be completed because there is not enough money in the account")
      end
    else
        if borrower.balance - self.amount < 0
          errors.add(:amount, "Transaction could not be completed because there is not enough money in the account")
        end
      end
  end

  def update_debit_credit

    lender = User.find(self.lender_id)
    borrower = User.find(self.borrower_id)

    d = Debit.find_or_create_by(lender_id: self.lender_id, borrower_id: self.borrower_id)
    c = Credit.find_or_create_by(lender_id: self.lender_id, borrower_id: self.borrower_id)

    if self.lending

        if lender.balance - self.amount >= 0
          d.amount += self.amount
          lender.update(balance: lender.balance - self.amount)
          borrower.update(balance: borrower.balance + self.amount)
        end
    else
        if borrower.balance - self.amount >= 0
          c.amount += self.amount
          lender.update(balance: lender.balance + self.amount)
          borrower.update(balance: borrower.balance - self.amount)
        end
    end
    d.save
    c.save
  end



end
