class AddLogoToFestivals < ActiveRecord::Migration[5.2]
  def change
    add_column :festivals, :logo, :string
  end
end
