class AddAuthorsIdToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :authors_id, :string
  end
end
