class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => 'User'
  belongs_to :relationship


    after_create :find_all_friendships
    after_create :set_relationship

    def find_all_friendships

        u=User.find(self.friend_id)
        if !u.friends.include?(User.find(self.user_id))
          u.friends << User.find(self.user_id)
          u.save
      end
    end

    def set_relationship
    
      self.relationship_id = 1
      self.save
    end

end
