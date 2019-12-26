class User < ActiveRecord::Base
  has_secure_password

  before_save { |user| user.email = email.downcase }

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password_digest, presence: true, length: { minimum: 6 }
  # validates :password_confirmation, presence: true

  def generate_password_token!
		self.reset_password_token = generate_token
		self.reset_password_sent_at = Time.now.utc
		save!
	end

	def password_token_valid?
		(self.reset_password_sent_at + 4.hours) > Time.now.utc
	end

	def reset_password!(password_digest)
		self.reset_password_token = nil
		self.password_digest = Digest::SHA1.hexdigest(password_digest)
		save!
	end

	private

	def generate_token
		SecureRandom.hex(10)
	end

end


# Crear Usuario
# User.create(name: "Admin", email: "contacto@reframe.cl", password: "RF123/()", password_confirmation: "RF123/()")