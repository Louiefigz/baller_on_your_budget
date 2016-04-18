class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :borrowed, :foreign_key => 'borrower_id', :class_name => 'Transaction'
  has_many :lent_out, :foreign_key => 'lender_id', :class_name => 'Transaction'
  has_many :lenders, through: :borrowed
  has_many :borrowers, through: :lent_out

  has_many :notes, through: :transactions


  def add_money(money)
    self.balance + money
  end

  def same_lender_update(lender)
    self.borrowed.each do |transaction|
      binding.pry

      if self.lender_ids.include?(lender.to_i)
        end
      end
    end

    def total_borrowed_from(lender_id)
      borrowed.where(lender_id: lender_id).sum(:amount)
    end

    def total_lended(borrower_id)
      lent_out.where(borrower_id: borrower_id).sum(:amount)
    end

    def unique_lenders
      lenders.distinct
    end

    def unique_borrowers
      borrowers.distinct
    end

  #   if self.lender_ids.include?(lender.to_i)
  #     lender = User.find(lender.to_i)
  #   end
  # end

end
