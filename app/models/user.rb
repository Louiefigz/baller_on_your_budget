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

  #
  # def keep_friends
  #
  # end






  #
  # def not_friends
  #   User.all.pluck(:id) - friend_ids
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
  binding.pry
  # I need this custom attr because without it, the friends that were previously saved are not appended to the new
  # friends that are added in the add_friend form.
attributes.each do |attribute|
  if attribute != ""
   friend = User.find(attribute)
      if !self.friends.include?(friend)
        self.friends << friend
      end
    end
 end
 self.save
end

def relationship_type
  binding.pry
end




def update_friends(user_name, e)
  # Here we are tricking Devise into creating a new object of a user and  creating a friendship table
  if user_name !="" && e !=""
    if existing_user = User.find_by(name: user_name.strip)
      Friendship.find_or_create_by(user_id: self.id, friend_id: existing_user.id)
    else
      person = User.new(name:user_name.strip, email: e)
      person.save(validate:false)
      new_friend =Friendship.create(user_id:self.id, friend_id:person.id)
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

def setting_default_relationship(drop_params)
  # This is a safe guard to make sure that there will always be a default relationship status.
  if drop_params[:relationship_id].to_i != 0

    word = drop_params[:relationship_id].to_i
  else
    word = 68
  end
  word
end

def friend_relationship(current_user, friend_id)
  # responsible to only return that relationship
  friendship = Friendship.find_by(user_id: current_user, friend_id: friend_id)
  if friendship.relationship == nil
     friendship.update(relationship_id: 1)
  end
  friendship.relationship.description
end

def setting_relationship_variable(current_user, new_user_info, word)
  # Here we are making the relationship either created or set from the drop down box equal to the
  #Friendship table status.
  new_friend_relationship = Friendship.find_or_create_by(user_id: current_user.id, friend_id: new_user_info)
  new_friend_relationship.update(relationship_id: word)
end


def creating_relationship_transaction_friend(user_name, rel_params, drop_params, amount_params, current_user)
  # If we are adding a new friend object.
  if user_name != ""
    #&& if there is no description (meaning if the user choose a relationship from drop down box or nothing at all)

    if rel_params[:description] == ""
        #setting a default status if none was chosen.
      word = self.setting_default_relationship(drop_params)
      # Taking the last user object created and setting the relationship status.  We are going to make sure that the Friendship status
      # is equal to the word.
      new_user_info = User.last.id
      # new_word = Relationship.find(word)
      self.setting_relationship_variable(current_user, new_user_info, word)
      # if the transaction is not zero, we're going to add money to that persons account.
      self.create_this_transaction(current_user, new_user_info, amount_params)
    else
      # if we are creating a friend && we are creating a new relationship status object in the text field..
      self.new_relationship_create_transaction(drop_params, rel_params, current_user, amount_params)
    end
  else
    # If we are not creating a new friend here && there was a new description written in the text field.
    # this means we are going to create that new word in the Relationship table.
    if rel_params[:description] != ""
      self.new_relationship_create_transaction(drop_params, rel_params, current_user, amount_params)
    end
  end
end

def new_relationship_create_transaction(drop_params, rel_params, current_user, amount_params)
  # setting the default relationship if one was not assigned from the drop down box
  self.setting_default_relationship(drop_params)
  # Here we are making sure that the text input finds or creates the word to prevent a duplicate object.
  word =Relationship.find_or_create_by(description: rel_params[:description])
  new_user_info = User.last.id
  #setting the relationship in the friendship table here.
  self.setting_relationship_variable(current_user, new_user_info, word.id)
  # I renamed the friend_id here again to match what the arguments were looking for.
  friend_id = User.last.id
  # If there was a transaction set,  the next line adds money to the account.
  self.create_this_transaction(current_user, friend_id, amount_params)
end

def update_relationship_variable(word, friend)

  friend.update(relationship_id: word)
end

# change this name to existing users instead of existing friends.
def create_attributes_with_existing_friends(drop_params, rel_params, user_params, current_user, amount_params)
  # This method is here to help create friendships with users that are in our database.
  # We are also iterating through the friend ids, making sure that they are given either a default relationship status or a new object,
  # Lastly, we are creating a transaction with those friends.

    word = self.setting_default_relationship(drop_params)
    # User did not give a relationship description(we're going to assign a default or the user chose a word from the drop down box)
    if rel_params[:description] == ""
        # We are looping through and assigning the friends in the params to have the appropriate relationship status and transaction.
      user_params[:friend_ids].each do |friend_att|

        if friend_att != ""
          friend = User.find(friend_att)
          set_friend = Friendship.find_or_create_by(friend_id: friend.id, user_id: current_user.id)
          self.update_relationship_variable(word, set_friend)
          friend = friend.id
          self.create_this_transaction(current_user, friend, amount_params)
        end
      end
    else
      # Here the text box is filled in and we are creating that object here.

      new_word =Relationship.find_or_create_by(description: rel_params[:description])
      user_params[:friend_ids].each do |friend_att|
        # We now want to set the friends to have that relationship status object and then do the transaction.
        if friend_att != ""
          friend = User.find(friend_att)
            set_relationship = Friendship.find_or_create_by(friend_id: friend.id, user_id: current_user.id)

            set_relationship.update(relationship_id: new_word.id)
            friend = friend.id
            self.create_this_transaction(current_user, friend, amount_params)
      end
    end
  end
end

def parse_add_form_data(user_params, user_name, drop_params, amount_params, current_user, rel_params)
  # The following 3 local variables are to account for creating a false validation of a new user
  # currently Devise gem does not create a new user without valid email and password.
  # the numbers and letters are randomly generated to create the email. This means that we are not able to Access
  # the users, we are only able to create them here.
  number = Random.rand(10000000)
  letters = [*('A'..'Z')].sample(8).join
  e = "#{number}#{letters}@gmail.com"
  # The User params are updating the friend_ids collection.  Updating the Users current friends.
  # the method below handles creating a new User object if the current user is creating a new friend and
  #adding them to their friends list. Again, Devise requires an email and password that we are falsely generating here.
  self.update(user_params)
  self.update_friends(user_name, e)
  # responsible to fire when we are creating a new friend. (creating new object of a user, Creating Friendship object, Creating Relationship, creating transaction.)
  self.creating_relationship_transaction_friend(user_name, rel_params, drop_params, amount_params, current_user )
  # responsible to fire to update the friends in the collection boxes. (Creating Friendship, creating Relationship, creating transaction for each instance of a friend.)
  self.create_attributes_with_existing_friends(drop_params, rel_params, user_params, current_user, amount_params)
end

end
