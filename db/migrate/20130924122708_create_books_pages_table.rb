class CreateBooksPagesTable < ActiveRecord::Migration
  def up
  	create_table :books_pages do |t|
      t.belongs_to :book
      t.belongs_to :page
    end
  end

  def down
  end
end
