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

  # POST welcome
  def welcome
    response = Twilio::TwiML::Response.new do |r|
      r.Gather numDigits: '1', action: menu_path do |g|
        g.Say "Thanks for calling All College Storage. If you require
        immediate assistance, we offer live chat support 24 7 on our website
        www dot all college storage dot com. You can also text 'HELP' to 000 000 0000
        and one of our customer service specialists will assist you right away.
        If you are a new customer and would like more information about our
        services, press 1. If you're an existing
        customer and require help, including technical assistance, press 2."
      end
    end
    render text: response.text
    @call = Call.create_from_twilio(params)
    @user = User.create_user(params)
  end

  # GET selection
  def menu_selection
    user_selection = params[:Digits]
    puts "menu"
    case user_selection
    when "1"
      new_customer

    when "2"
      current_customer

    else
      welcome
      # @output = "Returning to the main menu."
      # twiml_say(@output)
    end

  end

  def new_customer
    puts "new"

    message = "Need an easy solution to deal with all your school stuff over the summer?
    ACS has you covered. We'll pick your stuff up at your door, store it over the summer,
    and deliver it back to your new location in the fall. Need shipping? No problem,
    we ship anywhere internationally. All prices are per-item and include free packing
    materials, pickup, storage, and delivery. Our most popular item is our ACS box, which measures
    24 by 18 by 16 and costs $45 to store over the summer. If you need individual price quotes, please
    visit our website and select your school for pricing information. Do you still
    have unanswered questions? Please visit our website to chat with a customer service
    representative, or press 1 to request a call back."

    response = Twilio::TwiML::Response.new do |r|
      r.Gather numDigits: '1', action: request_call_path do |g|
        g.Say message, voice: 'alice', language: 'en-GB'
          r.Redirect welcome_path
      end
    end
    render text: response.text
  end

  def request_call
    user_selection = params[:Digits]
    message = "A customer service agent will give you a call back as soon
                as possible. Remember, it's always easier to go on our website
                and chat with a representative there."

    response = Twilio::TwiML::Response.new do |r|
      r.Say message, voice: 'alice', language: 'en-GB'

    case user_selection
    when "1"
      puts "notified"
      SlackPosterWorker.perform_async("#customerservice", "#{params["CallerName"]} requesting callback")
      twiml_say(@output, true)
    else # "0"
      @output = "Returning to the main menu."
      twiml_say(@output)
      end
    end
    render text: response.text
  end




  private

  def current_customer
    puts "current"

    message = "Need immediate assistance? Text HELP to 000 000 0000
    Or visit us at www.allcollegestorage.com and one of our customer service
    specialist will assist you via live chat. If you prefer an agent to give you
    a call within the next 24 hours, please press 1 to request a call back from our
    customer service team."

    response = Twilio::TwiML::Response.new do |r|
      r.Gather numDigits: '1', action: request_call_path do |g|
      g.Say message, voice: 'alice', language: 'en-GB'
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
        r.Say "Thank you for calling All College Storage. Have an awesome day!"
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
