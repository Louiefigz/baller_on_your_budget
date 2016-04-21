class Friendship < ActiveRecord::Base
  belongs_to :user
  before_action :authenticate_user!
  belongs_to :friend, :class_name => 'User'


    after_create :find_all_friendships

    def find_all_friendships
      binding.pry
        u=User.find(self.friend_id)
        u.friends << User.find(self.user_id)
        u.save


    end

end
