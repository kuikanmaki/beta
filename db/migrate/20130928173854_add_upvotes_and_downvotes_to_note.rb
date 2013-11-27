class AddUpvotesAndDownvotesToNote < ActiveRecord::Migration
  def change
    add_column :notes, :up_votes, :integer, :null => false, :default => 0
    add_column :notes, :down_votes, :integer, :null => false, :default => 0
  end
end
