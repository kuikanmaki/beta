class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :name
      t.string :slug
      t.string :author
      t.string :link
      t.references :page
      t.references :interest

      t.timestamps
    end
    #add_index :books, :slug, unique: true
    #add_index :books, :page_id
    #add_index :books, :interest_id
  end
end
