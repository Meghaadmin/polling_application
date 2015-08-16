class CreateElections < ActiveRecord::Migration
  def change
    create_table :elections do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.string :first_candidate
      t.string :second_candidate

      t.timestamps
    end
  end
end
