class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.string :title
      t.integer :sort
      t.integer :is_show

      t.timestamps
    end
  end
end
