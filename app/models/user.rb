# frozen_string_literal: true

class User < ApplicationRecord
  has_many :passengers, dependent: :destroy

  validates :name, :email, presence: true
  validates :token, presence: true, uniqueness: { case_sensitive: true }
end
