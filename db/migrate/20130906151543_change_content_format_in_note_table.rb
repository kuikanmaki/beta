class ChangeContentFormatInNoteTable < ActiveRecord::Migration
  def self.up
   change_column :notes, :content, :text
  end

  def self.down
   change_column :notes, :content, :string
  end
end
