class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable

  validates :fullname, presence: true, length: { maximum: 50 }

  has_many :venues
  has_one :band

  has_many :guest_reviews, class_name: 'GuestReview', foreign_key: 'guest_id'
  has_many :host_reviews, class_name: 'HostReview', foreign_key: 'host_id'
  has_many :notifications
  has_many :identities

  has_one :setting
  after_create :add_setting

  def add_setting
    Setting.create(user: self, enable_sms: true, enable_email: true)
  end

  # def self.from_omniauth(auth)
  #   user = User.where(email: auth.info.email).first
  #
  #   if user
  #     return user
  #   else
  #     where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #       user.email = auth.info.email
  #       user.password = Devise.friendly_token[0, 20]
  #       user.fullname = auth.info.name
  #       user.image = auth.info.image
  #       user.uid = auth.uid
  #       user.provider = auth.provider
  #
  #       # If you are using confirmable and the provider(s) you use validate emails,
  #       # uncomment the line below to skip the confirmation emails.
  #       user.skip_confirmation!
  #     end
  #   end
  # end

  def generate_pin
    self.pin = SecureRandom.hex(2)
    self.phone_verified = false
    save
  end

  def send_pin
    @client = Twilio::REST::Client.new
    @client.messages.create(
      from: '8053605998',
      to: phone_number,
      body: "Your pin is #{pin}"
    )
  end

  def verify_pin(entered_pin)
    update(phone_verified: true) if pin == entered_pin
  end

  def is_active_band
    merchant_id.present?
  end
end
