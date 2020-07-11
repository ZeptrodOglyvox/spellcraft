class User < ApplicationRecord
    attr_accessor :password
    before_save :encrypt_password

    has_many :spells, dependent: :destroy
    has_many :characters, dependent: :destroy

    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true, 'valid_email_2/email': true
    validates :password, presence: true, confirmation: true   
    validates :password_confirmation, presence: true
    

    def self.authenticate_by_email(email, password)
        user = User.find_by_email(email)
        if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
            user
        else
            nil
        end
    end

    def self.authenticate_by_username(username, password)
        user = User.find_by_username(username)
        if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
            user
        else
            nil
        end
    end

    def encrypt_password
        if password.present?
          self.password_salt = BCrypt::Engine.generate_salt
          self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
        end
    end
end
