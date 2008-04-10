$KCODE = "UTF-8"
$LOAD_PATH.unshift << File.join(File.dirname(__FILE__), "..", "lib")
require "kizapi"
require "rubygems"
require "bacon"

describe "KizAPI::RelatedWords" do
  it "should read date" do
    words = KizAPI::RelatedWords.new("季節")
    words.date.should.be.kind_of(Time)
  end

  it "day" do
    words = KizAPI::RelatedWords.day("季節")
    words.should.be.kind_of(Array)
    words.size.should > 0
  end

  it "week" do
    words = KizAPI::RelatedWords.week("季節")
    words.should.be.kind_of(Array)
    words.size.should > 0
  end

  it "month" do
    words = KizAPI::RelatedWords.month("季節")
    words.should.be.kind_of(Array)
    words.size.should > 0
  end
end

describe "KizAPI::KeywordInContexts" do
  it "should fetch sentences" do
    contexts = KizAPI::KeywordInContexts.new("季節")
    contexts.should.be.kind_of(Array)
    contexts.size.should > 0
    contexts.each do |context|
      context.should.be.kind_of(KizAPI::KeywordInContexts::Context)
      context.size.should > 0
      context.each do |sentence|
        sentence.should.be.kind_of(String)
      end
    end
  end

  it "KWIC is an alias" do
    KizAPI::KeywordInContexts.should == KizAPI::KWIC
  end
end

describe "KizAPI::Ranking" do
  it "should fetch keywords" do
    ranking = KizAPI::Ranking.new
    ranking.should.be.kind_of(Array)
    ranking.size.should == 30
    ranking.each do |keyword|
      keyword.should.be.kind_of(KizAPI::Ranking::Keyword)
      keyword.link.should.be.kind_of(URI)
    end
  end
end

describe "KizAPI::ChannelWords" do
  it "should fetch channel words" do
    words = KizAPI::ChannelWords.new("季節")
    words.date.should.be.kind_of(Time)
    words.should.be.kind_of(Array)
    words.size.should > 0
    words.each do |word|
      word.should.be.kind_of(KizAPI::ChannelWords::Word)
      word.should.respond_to(:subject)
    end
  end

  it "day" do
    words = KizAPI::ChannelWords.day("季節")
    words.should.be.kind_of(Array)
    words.size.should > 0
  end

  it "week" do
    words = KizAPI::ChannelWords.week("季節")
    words.should.be.kind_of(Array)
    words.size.should > 0
  end

  it "month" do
    words = KizAPI::ChannelWords.month("季節")
    words.should.be.kind_of(Array)
    words.size.should > 0
  end
end
