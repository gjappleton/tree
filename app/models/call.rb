class Call < ApplicationRecord
  belongs_to :user

  def self.create_from_twilio(params)
    # from = User.find_by_phone_number(params["From"])
    # if from.present?
    #   call =
    #   Call.create(
    #     phone_number: params["From"],
    #   )
    # else
    #   call =

    Call.create(
      phone_number: params["From"]
    )
      # from_name = params["CallerName"] || params["From"]
  end
end
