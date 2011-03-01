require 'spec_helper'

describe Guard::Pusher do

  describe "configuration" do
    context "provided through YAML file" do
      before(:each) do
        File.should_receive(:file?).
          with('config/pusher.yml').
          and_return(true)

        YAML.should_receive(:load_file).
          with('config/pusher.yml').
          and_return({ "development" => { "app_id" => 42, "key" => "fake_key", "secret" => "fake_secret" }})
      end

      it "requires 'app_id', 'key' and 'secret'" do
        Pusher.should_receive(:app_id=).with(42)
        Pusher.should_receive(:key=).with('fake_key')
        Pusher.should_receive(:secret=).with('fake_secret')
        Guard::UI.should_receive(:info).with(/.*Pusher is ready.*/, :reset => true)
        Guard::Pusher.new([])
      end
    end

    context "provided through options" do
      before(:each) do
        File.should_receive(:file?).
          with('config/pusher.yml').
          and_return(false)
      end

      it "requires 'app_id', 'key' and 'secret'" do
        Pusher.should_receive(:app_id=).with(42)
        Pusher.should_receive(:key=).with('fake_key')
        Pusher.should_receive(:secret=).with('fake_secret')
        Guard::UI.should_receive(:info).with(/.*Pusher is ready.*/, :reset => true)
        Guard::Pusher.new([], {
          :app_id => 42,
          :key    => 'fake_key',
          :secret => 'fake_secret'
        })
      end
    end

    context "missing the necessery keys" do
      before(:each) do
        File.should_receive(:file?).
          with('config/pusher.yml').
          and_return(false)
      end

      it "does not attempt to configure Pusher and issues a warning" do
        Pusher.should_not_receive(:app_id=)
        Guard::UI.should_receive(:info).with(/.*Pusher not properly configured.*/, :reset => true)
        Guard::Pusher.new([], {
          :key    => 'fake_key',
          :secret => 'fake_secret'
        })
      end
    end
  end

  describe "run_on_change" do
    it "sends Pusher message" do
      channel = mock(Pusher::Channel)
      Pusher.should_receive(:[]).with('guard-pusher').and_return(channel)
      channel.should_receive(:trigger).with('guard', {})
      subject.run_on_change(['foo'])
    end
  end

end
