class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :avatar, :description
  has_secure_password
  has_many :notes
  make_voter
  has_many :interests
  has_many :pages, through: :interests, :uniq => true
  accepts_nested_attributes_for :interests
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  has_attached_file :avatar, 
                                           :styles => { :medium => "300x300>", 
                                           :thumb => "100x100>" }, 
                                           :default_url => "default/userprofile.png",
                                           :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
                                           :url => "/system/:attachment/:id/:style/:filename",
                                           :storage => :s3,
                                           :s3_credentials => {:bucket => ENV['AWS_BUCKET'],
                                           :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
                                           :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']},
                                           :s3_protocol => "https",
                                           :s3_host_name => "s3-eu-west-1.amazonaws.com" 
  before_save { email.downcase! }
  #before_save :create_remember_token
  before_create :create_remember_token

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  
  validates :password, presence: true, :on => :create, length: { minimum: 6 }
  validates :password_confirmation, presence: true, :on => :create
  after_validation { self.errors.messages.delete(:password_digest) }

  include PublicActivity::Common
  #tracked

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

    include Mailboxer::Models::Messageable
  acts_as_messageable

  def mailboxer_email(message)
    email
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
