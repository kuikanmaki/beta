class AddInterests < ActiveRecord::Migration
  
  def change
    create_table :interests do |t|
    t.belongs_to :user
    t.belongs_to :page
    t.datetime :starting_date
    t.timestamps
    end
  end

end
