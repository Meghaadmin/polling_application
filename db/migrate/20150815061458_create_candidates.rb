class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.string :name
      t.string :age
      t.integer :admin_id

      t.timestamps
    end
  end
end
