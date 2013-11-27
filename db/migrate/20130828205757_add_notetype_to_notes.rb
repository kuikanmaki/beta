class AddNotetypeToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :notetype, :string
  end
end
