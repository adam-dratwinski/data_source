require 'spec_helper'

describe WordSource do
  subject { WordSource.new(source) }

  describe "#next_word" do
    let(:source) { "Lorem ipsum dolor sit Lorem ipsum" }

    it "goes to the first word when call first time" do
      subject.next_word.should == "Lorem"
    end

    it "returns second word if call next_word method twice" do
      subject.next_word
      subject.next_word.should == "ipsum"
    end
  end

  describe "#run" do
    let(:source) { "Lorem ipsum dolor" }

    it "increments current counter to 3" do
      subject.run
      subject.instance_variable_get(:"@current").should == 3
    end
  end

  describe "#top_5_words" do
    it "returns nil when we have less then 5 words" do
      word_source = WordSource.new("a b c")
      word_source.top_5_words.should == ["a", "b", "c", nil, nil]
    end

    it "returns most popular words first" do
      word_source = WordSource.new("a b d b c c c d d d ")
      word_source.top_5_words.should == ["d", "c", "b", "a", nil]
    end
  end

  describe "#top_5_consonants" do
    it "returns nil when we have less then 5 consonants" do
      word_source = WordSource.new("abcd")
      word_source.top_5_consonants.should == ["a", "b", "c", "d", nil]
    end

    it "returns most popular consonants" do
      word_source = WordSource.new("aaabbcdddd")
      word_source.top_5_consonants.should == ["d", "a", "b", "c", nil]
    end
  end

  describe "#count" do
    let(:source) { "lorem ipsum dolor lorem ipsum" }

    its(:count) { should == 3 }
  end

  describe "#add_callback" do
    let(:source) { "lorem ipsum dolor lorem ipsum lorem" }

    let(:callback_1) { Proc.new {} }
    let(:callback_2) { Proc.new {} }
    let(:callback_3) { Proc.new {} }

    it "adds callbackss to words and run it everytime when occures" do
      subject.add_callback "lorem", callback_1
      subject.add_callback "ipsum", callback_2
      subject.add_callback "ipsum", callback_3

      callback_1.should_receive(:call).with("lorem").exactly(3).times
      callback_2.should_receive(:call).with("ipsum").exactly(2).times
      callback_3.should_receive(:call).with("ipsum").exactly(2).times

      subject.run
    end
  end

  describe ".load_form_text_file" do
    let(:file_path) { File.expand_path('../fixtures/lorem_ipsum.txt', __FILE__) }
    
    subject { WordSource.load_from_text_file(file_path) }

    its(:top_5_words)       { should == ["sed", "vel", "vitae", "et", "in"] }
    its(:top_5_consonants)  { should == ["e", "i", "u", "s", "t"] }
    its(:count)             { should == 245 }
  end

  describe ".load_from_last_user_tweets" do
    let (:railscasts_tweets) { [
      OpenStruct.new(:text => "@jpinnix they seem to be working for me now. Are they working for you?"),
      OpenStruct.new(:text => "@jpinnix thanks for letting me know about this."),
      OpenStruct.new(:text => "@AstonJ I keep the 1 week extensions active for a few months, so you can activate them quite a while after the week."),
      OpenStruct.new(:text => "@andreas_codered thanks!"),
      OpenStruct.new(:text => "@shawnoneill_ca thanks for your support!"),
      OpenStruct.new(:text => "@mattgillooly some subscribers are kind enough to give me a week paid vacation."),
      OpenStruct.new(:text => "I am at the coast with my family so there wont be new episodes this week. Pro subscriber? Extend your subscription: http://t.co/xNRQ0kK8"),
      OpenStruct.new(:text => "@galtmidas thanks for the kind words!"),
      OpenStruct.new(:text => "Other episode videos are intermittent. Still working on getting those working. Sorry about the downtime. Thanks for your patience."),
      OpenStruct.new(:text => "I've setup a mirror for episode 400 which appears to be working. You can watch it now in case you were unable to: http://t.co/Ylv1zkid"),
      OpenStruct.new(:text => "@tanordheim sorry about that, working to get this back up as soon as possible."),
      OpenStruct.new(:text => "@rosstimson sorry about that, working to get this back up as soon as possible."),
      OpenStruct.new(:text => "@miha_mencin sorry about that, working to get this back up as soon as possible."),
      OpenStruct.new(:text => "@memoht sorry about that, working to get this back up as soon as possible."),
      OpenStruct.new(:text => "@bobclewell sorry about that, working to get this back up as soon as possible."),
      OpenStruct.new(:text => "@THEJonEvans sorry about that, working to get this back up as soon as possible."),
      OpenStruct.new(:text => "@phudgins sorry about that, working to get this back up as soon as possible."),
      OpenStruct.new(:text => "@talltroym sorry about that, working to get this back up as soon as possible."),
      OpenStruct.new(:text => "@ScottSwezey sorry about that, working to get this back up as soon as possible."),
      OpenStruct.new(:text => "@jacobatkins it appears so. :(")
    ]}

    subject { WordSource.load_from_last_user_tweets('railscasts') }

    before { TwitterApi.stub(:get_user_tweets => railscasts_tweets) }

    its(:top_5_words)       { should == ["as", "working", "to", "this", "about"] }
    its(:top_5_consonants)  { should == ["o", "t", "s", "e", "a"] }
    its(:count)             { should == 113 }
  end
end
