class AddDefaultAdmin < ActiveRecord::Migration
  def change
    User.create(:name=>"Admin",:email_id=>"pollingadmin@gmail.com",:user_type=>1,:password=>'P@ssc0de')
  end
end
