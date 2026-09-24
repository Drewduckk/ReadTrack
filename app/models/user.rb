class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy

  has_many :reading_assignments,
           foreign_key: :teacher_id

  has_many :summaries,
           foreign_key: :student_id

  has_many :reading_progresses,
           foreign_key: :student_id,
           dependent: :destroy

  normalizes :email_address, with: ->(email) { email.strip.downcase }

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true
  validates :password, length: { minimum: 12 }, allow_nil: true

  validates :email_change,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: { case_sensitive: false },
            allow_nil: true

  enum :role, {
  student: 0,
  teacher: 1,
  admin: 2
  }
end