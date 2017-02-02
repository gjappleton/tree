require 'twilio-ruby'
require 'sanitize'

account_sid = 'AC9baa7e1e25f32f41bd21d8922c3d3588'
auth_token = '5f1cf1cfe5ac6df736d8b8783645b563'

# set up a client to talk to the Twilio REST API
client = Twilio::REST::Client.new account_sid, auth_token

# list of incoming calls + numbers thru API

# calls = client.account.calls.list
#
# begin
#   calls.each do |call|
#     puts call.from
# end
#   calls = calls.next_page
# end while not calls.empty?

class TwilioController < ApplicationController

  def index
    render text: "Phone Tree."
  end

  # POST ivr/welcome
  def ivr_welcome
    response = Twilio::TwiML::Response.new do |r|
      r.Gather numDigits: '1', action: menu_path do |g|
        g.Play "http://howtodocs.s3.amazonaws.com/et-phone.mp3", loop: 3
      end
    end
    render text: response.text
    @call = Call.create_from_twilio(params)
    @user = User.create_user(params)
  end

  # GET ivr/selection
  def menu_selection
    user_selection = params[:Digits]

    case user_selection
    when "1"
      @output = "arise ye loyal sons of sigma phi, draw near our conclave's sacred shrine. breathe deep, and long, of incense sweet. till the pulse throbs with fire divine, divine, till the pulse throbs with fire divine. our virtues may we ever cherish. friendship love and truth undefiled. from honor stainless never beguiled. may the thrice illustrious ever flourish. long live the sigma phi. loud ring her battle cry. the sigma phi all hail her name, esto, perpetua."
      twiml_say(@output, true)
    when "2"
      list_planets
    else
      @output = "Returning to the main menu."
      twiml_say(@output)
    end

  end

  # POST/GET ivr/planets
  # planets_path
  def planet_selection
    user_selection = params[:Digits]

    case user_selection
    when "2"
      twiml_dial("+12024173378")
    when "3"
      twiml_dial("+12027336386")
    when "4"
      twiml_dial("+12027336637")
    else
      @output = "Returning to the main menu."
      twiml_say(@output)
    end
  end

  private

  def list_planets
    message = "To call the planet Broh doe As O G, press 2. To call the planet
    DuhGo bah, press 3. To call an oober asteroid to your location, press 4. To
    go back to the main menu, press the star key."

    response = Twilio::TwiML::Response.new do |r|
      r.Gather numDigits: '1', action: planets_path do |g|
        g.Say message, voice: 'alice', language: 'en-GB', loop:3
      end
    end

    render text: response.text
  end

  def twiml_say(phrase, exit = false)
    # Respond with some TwiML and say something.
    # Should we hangup or go back to the main menu?
    response = Twilio::TwiML::Response.new do |r|
      r.Say phrase, voice: 'alice', language: 'en-GB'
      if exit
        r.Say "Thank you for calling the ET Phone Home Service - the
        adventurous alien's first choice in intergalactic travel."
        r.Hangup
      else
        r.Redirect welcome_path
      end
    end

    render text: response.text
  end

  def twiml_dial(phone_number)
    response = Twilio::TwiML::Response.new do |r|
      r.Dial phone_number
    end

    render text: response.text
  end
end
