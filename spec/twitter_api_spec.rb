require 'spec_helper'

describe TwitterApi do
  describe ".get_user_tweets" do
    it "gets user tweets" do
      Twitter.should_receive(:user_timeline).with('twitter')
      TwitterApi.get_user_tweets('twitter')
    end
  end
end
