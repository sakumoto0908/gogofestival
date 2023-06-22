class AddFestivalIdToTopics < ActiveRecord::Migration[5.2]
  def change
    add_column :topics, :festival_id, :integer
  end
end
