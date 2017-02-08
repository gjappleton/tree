class Call < ApplicationRecord
  belongs_to :user, optional: true

  def self.create_from_twilio(params)
    from = User.find_by_phone_number(params["From"])
    # if from.present?
    #   call =
    #   Call.create(
    #     phone_number: params["From"],
    #   )
    # else
    #   call =
    if from.present?
      Call.create(
        phone_number: params["From"],
        user_id: from.id
      )
      puts "hi"
    else
      Call.create(
        phone_number: params["From"]
      )
      puts "hey"
    end
  end
end
