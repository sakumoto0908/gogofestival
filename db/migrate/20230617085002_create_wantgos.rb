class CreateWantgos < ActiveRecord::Migration[5.2]
  def change
    create_table :wantgos do |t|
      t.integer :user_id
      t.integer :festival_id

      t.timestamps
    end
  end
end
