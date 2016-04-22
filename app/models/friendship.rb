class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => 'User'


    after_create :find_all_friendships

    def find_all_friendships
        u=User.find(self.friend_id)
        if !u.friends.include?(User.find(self.user_id))
          u.friends << User.find(self.user_id)
          u.save
      end
    end

end
