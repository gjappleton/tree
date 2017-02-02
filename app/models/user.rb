class User < ApplicationRecord
  has_many :calls

  def self.create_user(params)
    User.create(
      phone_number: params["From"]
    )
  end

  # def self.find_by_phone_number(phone_number)
  #   return unless phone_number.present?
  #   User.find_by(phone_number: number.gsub("+1","").gsub(/\D/,""))
  # end

end
