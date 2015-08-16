class User < ActiveRecord::Base

  has_one :voting  ,:foreign_key => 'selector_id'

  def self.selectors
   users =  User.where(:user_type => $is_selector)
  end

end
