require "uri"
require "open-uri"
require "rss"
require "time"

# import Dublin Core into RSS 2.0
module RSS #:nodoc:
  class Rss #:nodoc:
    install_ns(DC_PREFIX, DC_URI)
    class Channel #:nodoc:
      include DublincoreModel
    end
    class Channel::Item #:nodoc:
      include DublincoreModel
    end
  end
end

module KizAPI
  module Version #:nodoc:
    MAJOR = 0
    MINOR = 2
    TINY  = 0

    STRING = [MAJOR, MINOR, TINY].join('.')
  end

  VERSION = Version::STRING

  # RelatedWords is a class for searching related words of a keyword.
  class RelatedWords < Array
    attr_reader :keyword, :span
    # measured time
    attr_reader :date

    # Make a list of related words of a keyword.
    # keyword:: keyword in UTF-8
    # span:: "24", "1w", or "1m"
    def initialize(keyword, span="24")
      @keyword = keyword
      @span = span
      uri = URI.parse(URI.escape(<<-URL.chomp))
http://kizasi.jp/kizapi.py?span=#{span}&kw_expr=#{keyword}&type=coll
      URL
      rss = RSS::Parser.parse(uri.read)
      @date = rss.channel.lastBuildDate
      super(rss.items.map{|item| item.title})
    end

    # Same as RelatedWords.new(keyword, "24").
    def self.day(keyword)
      new(keyword, "24")
    end

    # Same as RelatedWords.new(keyword, "1w").
    def self.week(keyword)
      new(keyword, "1w")
    end

    # Same as RelatedWords.new(keyword, "1m").
    def self.month(keyword)
      new(keyword, "1m")
    end
  end

  # KeyWordInContext is a class for fetching 3 sentences in context including a keyword.
  class KeywordInContexts < Array
    class Context < Array
      attr_reader :title, :link, :date
      def initialize(item)
        @title = item.title
        @date = item.pubDate
        @link = URI.parse(item.link)
        item.description.split("<br>")[0..2].each do |s|
          push s unless /^<ul>/.match(s)
        end
      end
    end

    attr_reader :date, :keyword

    # Fetch 3 sentences
    def initialize(keyword)
      @keyword = keyword
      uri = URI.parse(URI.escape(<<-URL.chomp))
http://kizasi.jp/kizapi.py?kw_expr=#{keyword}&type=kwic
      URL
      rss = RSS::Parser.parse(uri.read)
      @date = rss.channel.lastBuildDate
      super(rss.items.map{|item| Context.new(item)})
    end
  end

  # KWIC is an alias of KeywordInContext.
  KWIC = KeywordInContexts

  # Ranking is a class for fetching TOP 30 keywords in kizasi.jp ranking.
  class Ranking < Array
    class Keyword < String
      # URL in kizasi.jp
      attr_reader :link
      def initialize(item)
        super(item.title)
        @link = URI.parse(item.link)
      end
    end

    # published date
    attr_reader :date

    def initialize
      uri = URI.parse("http://kizasi.jp/kizapi.py?type=rank")
      rss = RSS::Parser.parse(uri.read)
      @date = rss.channel.lastBuildDate
      super(rss.items.map{|item| Keyword.new(item)})
    end
  end

  # ChannelWords is a class for fetching co-occurrence channel words of a keyword.
  class ChannelWords < Array
    class Word < String
      attr_reader :subject
      def initialize(item)
        super(item.title)
        @subject = item.dc_subject
      end
    end

    attr_reader :keyword, :span

    # published date
    attr_reader :date

    # Make a list of co-occurrence channel words of a keyword.
    # keyword:: keyword in UTF-8
    # span:: "24", "1w", or "1m"
    def initialize(keyword, span="24")
      @keyword = keyword
      @span = span
      uri = URI.parse(URI.escape(<<-URL.chomp))
http://kizasi.jp/kizapi.py?span=#{span}&kw_expr=#{keyword}&type=channel
      URL
      rss = RSS::Parser.parse(uri.read, true, false)
      @date = rss.channel.lastBuildDate
      super(rss.items.map{|item| Word.new(item)})
    end

    # Same as ChannelWords.new(keyword, "24").
    def self.day(keyword)
      new(keyword, "24")
    end

    # Same as ChannelWords.new(keyword, "1w").
    def self.week(keyword)
      new(keyword, "1w")
    end

    # Same as ChannelWords.new(keyword, "1m").
    def self.month(keyword)
      new(keyword, "1m")
    end
  end

end
