require 'spec_helper'

describe Guard::Pusher do

  describe "options" do
    context "Pusher not configured" do
      it "requires 'app_id', 'key' and 'secret'" do
        Pusher.should_receive(:app_id=).with('1234')
        Pusher.should_receive(:key=).with('key')
        Pusher.should_receive(:secret=).with('secret')
        Guard::Pusher.new([], {
          :app_id => '1234',
          :key    => 'key',
          :secret => 'secret'
        })
      end
    end

    context "Pusher already configured" do
      it "does not require 'app_id', 'key' and 'secret'" do
        Pusher.app_id = "1234"
        Pusher.key = "key"
        Pusher.secret = "secret"
        Pusher.should_not_receive(:app_id=)
        Pusher.should_not_receive(:key=)
        Pusher.should_not_receive(:secret=)
        Guard::Pusher.new([], {
          :app_id => '1234',
          :key    => 'key',
          :secret => 'secret'
        })
      end
    end
  end

  describe "run_on_change" do
    it "sends Pusher message" do
      channel = mock(Pusher::Channel)
      Pusher.should_receive(:[]).with('guard-pusher').and_return(channel)
      channel.should_receive(:trigger).with('reload', {})
      subject.run_on_change(['foo'])
    end
  end

end
