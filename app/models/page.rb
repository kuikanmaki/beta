class Page  < ActiveRecord::Base
  has_many :notes
  has_many :interests
  has_many :users, through: :interests
  has_and_belongs_to_many :books
  validates :name, :presence => true, length: { maximum: 100 }
  attr_accessible :name, :parent, :definition, :image, :coverimage, :coverimage_file_name, :image_file_name
  extend FriendlyId
  friendly_id :name, use: :slugged
  has_attached_file :image, 
                                           :styles => { :medium => "300x300>", 
                                           :thumb => "100x100>" }, 
                                           :default_url => "default/noisygrid.png",
                                           :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
                                           :url => "/system/:attachment/:id/:style/:filename"
  has_attached_file :coverimage,  
                                           :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
                                           :url => "/system/:attachment/:id/:style/:filename", 
                                           :storage => :s3,
                                           :s3_credentials => {:bucket => ENV['AWS_BUCKET'],
                                           :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
                                           :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']},
                                           :s3_protocol => "https",
                                           :s3_host_name => "s3-eu-west-1.amazonaws.com"                                                                                 
  #validates_attachment_presence :image
  default_scope :order => 'name ASC'
  has_and_belongs_to_many :parentpages, 
                                           :class_name => "Page",
                                           :association_foreign_key => "parentpage_id",
                                           :join_table => "pages_parentpages"
  has_and_belongs_to_many :subpages, 
                                           :class_name => 'Page',
                                           :foreign_key => 'parentpage_id',
                                           :association_foreign_key => 'page_id',
                                           :join_table => 'pages_parentpages'  
  has_and_belongs_to_many :relatedpages, 
                                           :class_name => "Page",
                                           :foreign_key => "relatedpage_id",
                                           :join_table => "pages_relatedpages"
  include PublicActivity::Common
  #tracked owner: Proc.new{ |controller, model| controller.current_user }                                        
end