class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  has_many :band_likes
  has_many :liked_bands, through: :band_likes, source: :band, dependent: :destroy
  has_many :created_bands, class_name: "Band", dependent: :nullify
  has_many :genre_groups, dependent: :destroy

  before_destroy :destroy_band_references

  before_validation :fix_email

  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9]+\z/
  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :username, presence: true, format: { with: VALID_USERNAME_REGEX, message: "can only contain letters or numbers" }, uniqueness: true
  validates :email, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }, allow_nil: true
  has_secure_password
  validates :password, length: { minimum: 6 }, allow_nil: true

  def to_param
    username
  end

  def remember
    self.remember_token = User.new_token
    update( remember_digest: User.digest( remember_token ) )
  end

  def forget
    update( remember_digest: nil )
  end

  def authenticated?( attribute, token )
    digest = send( "#{attribute}_digest" )
    return false if digest.nil?
    BCrypt::Password.new( digest ).is_password?( token )
  end

  def activate
    update( activated: true, activated_at: Time.zone.now )
  end

  def send_activation_email
    create_activation_digest
    UserMailer.account_activation( self ).deliver_now
  end

  def send_password_reset_email
    create_reset_digest
    UserMailer.password_reset( self ).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def like( band )
    liked_bands << band
  end

  def unlike( band )
    liked_bands.destroy( band )
  end

  def likes?( band )
    liked_bands.exists?( band.id )
  end

  def User.digest( string )
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create( string, cost: cost )
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  private

    def fix_email
      if email.blank?
        self.email = nil
      else
        email.downcase!
      end
    end

    def create_reset_digest
      self.reset_token = User.new_token
      self.reset_digest = User.digest( reset_token )
      self.reset_sent_at = Time.zone.now
      save!
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest( activation_token )
      save!
    end

    def destroy_band_references
      Band.where( user: self ).update( user: nil )
    end
end
