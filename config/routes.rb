Rails.application.routes.draw do

  # Root of the app
  root 'twilio#index'

  # webhook for your Twilio number
  match 'welcome' => 'twilio#welcome', via: [:get, :post], as: 'welcome'

  # callback for user entry
  match 'selection' => 'twilio#menu_selection', via: [:get, :post], as: 'menu'

  # callback for requesting a callback (pun intended)
  match 'request-call' => 'twilio#request_call', via: [:get, :post], as: 'request_call'

  post  'incoming-message' => 'twilio#incoming_message'

  post 'call' => 'twilio#call', as: 'call'
  post 'connect' => 'twilio#connect', as: 'connect'
  post 'status' => 'twilio#status', as: 'status'
end
