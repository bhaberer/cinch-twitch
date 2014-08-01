require 'cinch'
require 'twitch'
require 'time-lord'

module Cinch
  module Plugins
    # Cinch Plugin to monitor twitch streams and announce when they are live.
    class TwitchTV
      include Cinch::Plugin

      match(/stream/)
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
        if @currently_live == live?
          debug "Stream is currently [#{live? ? 'Online' : 'Offline'}]"
          return
        end
        debug "Stream status changed to [#{live? ? 'Online' : 'Offline'}]"
        @bot.channels.first.msg(online_message) if live?
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
        return 'Stream is offline' if offline?

        info = acquire_stream_info
        "#{info[:channel_name]} started broadcasting " \
        "#{info[:started_at].ago.to_words}; listen along at #{info[:url]}"
      end

      def online_message
        info = acquire_stream_info
        "#{info[:channel_name]} is now Online at #{info[:url]}" unless info.nil?
      end

      def acquire_stream_info
        stream = Twitch.new.getStream(@streamid)[:body]['stream']
        return nil if stream.nil? || !stream.key?('channel')
        channel = stream['channel']

        { viewers: stream['viewers'],
          channel_name: channel['display_name'],
          started_at: Time.parse(channel['updated_at']),
          url: channel['url'] }
      end
    end
  end
end
