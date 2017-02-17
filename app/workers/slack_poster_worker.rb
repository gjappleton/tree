class SlackPosterWorker
  include Sidekiq::Worker

  def perform(channel, text)
    url = 'https://slack.com/api/chat.postMessage'

    Typhoeus.post(
      url,
      body: {
        token: ENV['SLACK_TOKEN'],
        channel: filtered_channel(channel),
        text: text
      }
    )
  end

  private

  def filtered_channel(channel)
    Rails.env == 'production' ? channel : ENV['SLACK_DEV_CHANNEL']
  end

  def filtered_text(text)
    Rails.env == 'production' ? text : "#{ENV['APP_NAME']} #{text}"
  end

end
