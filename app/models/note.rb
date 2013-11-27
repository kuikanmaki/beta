class Note < ActiveRecord::Base
  belongs_to :page
  belongs_to :user
  make_voteable
  default_scope -> { order('created_at DESC') }
  validates :title, presence: true
  validates :content, presence: true
  validates :user_id, presence: true
  attr_accessible :content, :user_id, :page, :title
  include PublicActivity::Common
  #tracked owner: Proc.new{ |controller, model| controller.current_user }
end
