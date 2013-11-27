class CreatePagesParentpages < ActiveRecord::Migration
  def change
    create_table :pages_parentpages, :id => false do |t|
      t.references :page, :parentpage
    end

    add_index :pages_parentpages, [:page_id, :parentpage_id],
      name: "pages_parentpages_index",
      unique: true
  end
end
