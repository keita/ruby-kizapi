require File.dirname(__FILE__) + '/spec_helper.rb'

describe KizAPI::RelatedWords do
  before(:all) do
    @words = KizAPI::RelatedWords.new("季節")
  end

  after(:all) do
    @words = nil
  end

  it "can read date" do
    @words.date.should be_a_kind_of(Time)
  end

  it "#day" do
    words = KizAPI::RelatedWords.day("季節")
    words.should be_a_kind_of(Array)
    words.size.should > 0
  end

  it "#week" do
    words = KizAPI::RelatedWords.week("季節")
    words.should be_a_kind_of(Array)
    words.size.should > 0
  end

  it "#month" do
    words = KizAPI::RelatedWords.month("季節")
    words.should be_a_kind_of(Array)
    words.size.should > 0
  end
end

describe KizAPI::KeywordInContexts do
  it "fetch sentences" do
    contexts = KizAPI::KeywordInContexts.new("季節")
    contexts.should be_a_kind_of(Array)
    contexts.size.should > 0
    contexts.each do |context|
      context.should be_a_kind_of(KizAPI::KeywordInContexts::Context)
      context.size.should > 0
      context.each do |sentence|
        sentence.should be_a_kind_of(String)
      end
    end
  end

  it "KWIC is an alias" do
    KizAPI::KeywordInContexts.equal?(KizAPI::KWIC)
  end
end

describe KizAPI::Ranking do
  it "can fetch keywords" do
    ranking = KizAPI::Ranking.new
    ranking.should be_a_kind_of(Array)
    ranking.size.should == 30
    ranking.each do |keyword|
      keyword.should be_a_kind_of(KizAPI::Ranking::Keyword)
      keyword.link.should be_a_kind_of(URI)
    end
  end
end

describe KizAPI::ChannelWords do
  it "can fetch channel words" do
    words = KizAPI::ChannelWords.new("季節")
    words.date.should be_a_kind_of(Time)
    words.should be_a_kind_of(Array)
    words.size.should > 0
    words.each do |word|
      word.should be_a_kind_of(KizAPI::ChannelWords::Word)
      word.should respond_to(:subject)
    end
  end

  it "#day" do
    words = KizAPI::ChannelWords.day("季節")
    words.should be_a_kind_of(Array)
    words.size.should > 0
  end

  it "#week" do
    words = KizAPI::ChannelWords.week("季節")
    words.should be_a_kind_of(Array)
    words.size.should > 0
  end

  it "#month" do
    words = KizAPI::ChannelWords.month("季節")
    words.should be_a_kind_of(Array)
    words.size.should > 0
  end
end
