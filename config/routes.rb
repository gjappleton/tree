Rails.application.routes.draw do

  # Root of the app
  root 'twilio#index'

  # webhook for your Twilio number
  match 'welcome' => 'twilio#welcome', via: [:get, :post], as: 'welcome'

  # callback for user entry
  match 'selection' => 'twilio#menu_selection', via: [:get, :post], as: 'menu'

  # callback for planet entry
  match 'planets' => 'twilio#planet_selection', via: [:get, :post], as: 'planets'

end
