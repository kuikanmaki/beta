class AddDefinitionToPages < ActiveRecord::Migration
  def change
    add_column :pages, :definition, :string
  end
end
