class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :password
      t.string :user_type
      t.string :email_id
      t.string :is_approved

      t.timestamps
    end
  end
end
