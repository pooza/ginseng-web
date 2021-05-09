module Ginseng
  module Web
    class RSS20FeedRenderer < FeedRenderer
      def type
        return 'application/rss+xml; charset=UTF-8'
      end

      def feed
        @feed ||= RSS::Maker.make('rss2.0') do |maker|
          maker.items.do_sort = true
          maker.channel.id = channel[:link]
          channel.each {|k, v| maker.channel.send("#{k}=", v)}
          entries.each do |entry|
            maker.items.new_item do |item|
              if info = fetch_image(entry.dig('enclosure', 'url'))
                info.each {|k, v| item.enclosure.send("#{k}=", v)}
                entry.delete('enclosure')
              end
              entry.each {|k, v| item.send("#{k}=", v)}
            end
          end
        end
        return @feed
      end
    end
  end
end
