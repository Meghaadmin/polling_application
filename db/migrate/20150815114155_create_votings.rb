class CreateVotings < ActiveRecord::Migration
  def change
    create_table :votings do |t|
      t.integer :selector_id
      t.integer :candidate_id
      t.integer :election_id

      t.timestamps
    end
  end
end
