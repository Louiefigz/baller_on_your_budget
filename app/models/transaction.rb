class Transaction < ActiveRecord::Base

  belongs_to :user
  belongs_to :lender, :class_name => 'User'#, foreign_key: 'lender_id'
  belongs_to :borrower, :class_name => 'User'#, foreign_key: 'borrower_id'


  validates :amount, :numericality => { :only_integer => true, :greater_than => 0 }

  scope :biggest, -> { order ('amount DESC LIMIT 5') }


  after_create :update_debit_credit

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


  def create_this_transaction(current_user, friend, amount_params)
    if amount_params != ""
      @transaction = Transaction.new(lender_id: current_user.id, borrower_id: friend.to_i, amount: amount_params)

      if @transaction.save
      else
        flash[:message] = @transaction.errors.full_messages[0]
        redirect_to user_friendship_path(current_user.id, params[:transaction][:lender_id])
      end
    end

  end


end
