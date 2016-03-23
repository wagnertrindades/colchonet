class User < ActiveRecord::Base
  has_many :rooms, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  # Scopes examples
  #scope :most_recent, -> { order('created_at DESC') }
  #scope :from_sampa, -> { where(:location => 'São Paulo') }

  # scope :from_location, ->(location) { where(:location => location) }
  scope :confirmed, -> { where('confirmed_at IS NOT NULL') }

  validates_presence_of :email, :full_name, :location
  validates_length_of :bio, :minimum => 30, :allow_blank => false
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates_uniqueness_of :email

  has_secure_password

  before_create :generate_token

  # Default Scope
  # def self.default_scope
  #    where('confirmed_at IS NOT NULL')
  # end

  def self.authenticate(email, password)
    confirmed
      .find_by_email(email)
      .try(:authenticate, password)
  end

  def generate_token
    self.confirmation_token = SecureRandom.urlsafe_base64
  end

  def confirm!
    return if confirmed?

    self.confirmed_at = Time.current
    self.confirmation_token = ''
    save!
  end

  def confirmed?
    confirmed_at.present?
  end
end
