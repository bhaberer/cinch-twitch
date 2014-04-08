require 'cinch'
require 'twitch'
require 'time-lord'

module Cinch::Plugins
  class TwitchTV
    include Cinch::Plugin

    match /stream/
    timer 30, method: :live_check

    def initialize(*args)
      super
      @streamid = config[:streamid]
      @currently_live = live?
    end

    def execute(m)
      m.reply stream_message, true
    end

    def live_check
      debug "Stream is currently [#{live? 'Online' : 'Offline'}]"
      return if @currently_live == live?
      debug 'Stream status changed'
      @bot.channels.first.msg status_message if live?
      @currently_live = live?
    end

    private

    def live?
      !offline?
    end

    def offline?
      acquire_stream_info.nil?
    end

    def stream_message
      return 'Steam is offline' if offline?

      info = acquire_stream_info
      [info[:channel_name],
       'started broadcasting',
        "#{info[:started_at].ago.to_words};",
        'listen along at', info[:url]].join(' ')
    end

    def status_message
      info = acquire_stream_info
      [info[:channel_name],
      'is now',
      "#{live? ? "Online at #{info[:url]}" : 'Offline.'}"].join(' ')
    end

    def acquire_stream_info
      stream = Twitch.new.getStream(@streamid)[:body]['stream']
      return nil if stream.nil?

      { viewers: stream['viewers'],
        channel_name: stream['channel']['display_name'],
        started_at: Time.parse(stream['channel']['updated_at']),
        url: stream['channel']['url'] }
    end
  end
end
