class AddCoverToPages < ActiveRecord::Migration
def self.up
    change_table :pages do |t|
      t.attachment :coverimage
    end
  end

  def self.down
    drop_attached_file :pages, :coverimage
  end
end
