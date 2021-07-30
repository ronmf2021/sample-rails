class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :title
      t.integer :sort
      t.integer :is_show
      t.integer :author_id
      t.datetime :publish_date

      t.timestamps
    end
  end
end
