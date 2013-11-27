class CreatePagesRelatedpages < ActiveRecord::Migration
  def change
    create_table :pages_relatedpages, :id => false do |t|
      t.references :page, :relatedpage
    end

    add_index :pages_relatedpages, [:page_id, :relatedpage_id],
      name: "pages_relatedpages_index",
      unique: true
  end
end
