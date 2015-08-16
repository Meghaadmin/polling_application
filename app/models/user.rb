class User < ActiveRecord::Base

  def self.selectors
   users =  User.where(:user_type => 2)
  end

end
