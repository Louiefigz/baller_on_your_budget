class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [ :facebook, :google_oauth2]

  has_many :borrowed, :foreign_key => 'borrower_id', :class_name => 'Transaction'
  has_many :lent_out, :foreign_key => 'lender_id', :class_name => 'Transaction'
  has_many :lenders, through: :borrowed
  has_many :borrowers, through: :lent_out
  has_many :debits, foreign_key: 'borrower_id'
  has_many :debits, foreign_key: 'lender_id'
  has_many :credits, foreign_key: 'lender_id'
  has_many :credits, foreign_key: 'borrower_id'

  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :relationships

  #  accepts_nested_attributes_for :fr


  scope :lent_amount, -> { order ('lent_out DESC LIMIT 5') }

  attr_accessor :flash_notice

# def friend_ids=(attributes)
#   binding.pry
# end


  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
    end
  end




  def add_money(money)
    self.balance + money
  end

    # def total_borrowed_from(lender_id)
    #   borrowed.where(lender_id: lender_id).sum(:amount)
    # end
    #
    # def total_lended(borrower_id)
    #   lent_out.where(borrower_id: borrower_id).sum(:amount)
    # end
    #
    def unique_lenders
      lenders.distinct
    end
    #
    def unique_borrowers
      borrowers.distinct
    end

    def total_amount_due(current_user, lender)
       debit= Debit.find_or_create_by(borrower_id: current_user.id, lender_id: lender.id)
       credit = Credit.find_or_create_by(borrower_id: current_user.id, lender_id: lender.id)

       debit.amount - credit.amount
    end

    def borrower_total_amount_due(current_user, borrower)
       debit= Debit.find_or_create_by(borrower_id: borrower.id, lender_id: current_user.id)
       credit = Credit.find_or_create_by(borrower_id: borrower.id, lender_id: current_user.id)

       debit.amount - credit.amount
    end

    def lender_amount_not_zero(current_user)
      collection = []
      unique_lenders.each do |lender|

        if lender.total_amount_due(current_user, lender) != 0
          collection << lender
        end
      end
      collection
    end

    def borrower_amount_not_zero(current_user)
      collection = []
      unique_borrowers.each do |borrower|

        if borrower_total_amount_due(current_user, borrower) != 0
          collection << borrower
        end
      end
      collection
    end

    def overpaid_lender(current_user)
      collection = []
      lender_amount_not_zero(current_user).each do |lender|
      if total_amount_due(current_user, lender) < 0
        collection << lender
        end
      end
      collection
    end

    def display_overpaid_amount(current_user, user)
      current_user.overpaid_lender(current_user).include?(user)
    end

    def overpaid_borrower(current_user)
      collection = []
      borrower_amount_not_zero(current_user).each do |borrower|
      if borrower.borrower_total_amount_due(current_user, borrower) < 0
        collection << borrower
        end
      end
      collection
    end

def return_json

    return_val = []
    self.friends.each do |friend|
      obj = {}
      obj[:friend] = friend
      obj[:amount] = self.total_amount_due(self, friend)
      obj[:borrower] = self.borrower_total_amount_due(self, friend)
      return_val << obj
    end
    return_val
end


################## Parse Add Friend Form data from UsersController. ########



def add_friend_ids=(attributes)
  # I need this custom attr because without it, the friends that were previously saved are not appended to the new
  # friends that are added in the add_friend form.
attributes[:friend_ids].each do |attribute|
  if attribute != ""
   friend = User.find(attribute)
   create_this_transaction(self, friend.id, attributes[:transactions][:amount])
   set_relationship_for_friendship(friend, attributes)
      if !self.friends.include?(friend)
        self.friends << friend
      end
    end
 end
 self.save
end


def set_relationship_for_friendship(friend, attributes)
  @new_friendship = Friendship.find_or_create_by(user_id: self.id, friend_id: friend.id)
 if attributes[:relationship_type][:description] != ""
     status = Relationship.find_or_create_by(description: attributes[:relationship_type][:description].strip)
      @new_friendship.update(relationship_id: status.id)
 else
   if attributes[:relationship_type][:drop_down] != ""
       @new_friendship.update(relationship_id: attributes[:relationship_type][:drop_down])
     else
       @new_friendship.update(relationship_id: 1)
   end
  end
end



def create_this_transaction(current_user, friend, amount_params)

  #transactions are optional in the add_friend form.  If the value comes back greater than 0. We are going to create a lending transaction.
  if amount_params != "" && amount_params != "0"
    @transaction = Transaction.new(lender_id: current_user.id, borrower_id: friend, amount: amount_params)
  
    if @transaction.save
    else
      self.flash_notice = @transaction.errors.full_messages[0]
    end
  end
end


def friend_relationship(current_user, friend_id)
  # responsible to only return that relationship
  friendship = Friendship.find_by(user_id: current_user, friend_id: friend_id)
  if friendship.relationship == nil
     friendship.update(relationship_id: 1)
  end
  friendship.relationship.description
end


end
