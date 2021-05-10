module Ginseng
  module Web
    class AtomFeedRenderer < FeedRenderer
      def type
        return 'application/atom+xml; charset=UTF-8'
      end

      def feed
        @feed ||= RSS::Maker.make('atom') do |maker|
          maker.items.do_sort = true
          maker.channel.id = channel[:link]
          channel.each {|k, v| maker.channel.send("#{k}=", v)}
          entries.each do |entry|
            maker.items.new_item do |item|
              entry.each {|k, v| item.send("#{k}=", v)}
            end
          rescue => e
            @logger.error(error: e, entry: entry)
          end
        end
        return @feed
      end
    end
  end
end
