require 'spec_helper'

describe Guard::Pusher do

  def with_yaml(config = nil)
    config ||= {
      'development' => {
        'app_id' => 42,
        'key'    => 'fake_key',
        'secret' => 'fake_secret'
      }
    }

    File.should_receive(:file?).with('config/pusher.yml').and_return(true)
    File.should_receive(:read).with('config/pusher.yml')
    ERB.should_receive(:new).and_return(double('erb', :result => 'erb_foo'))
    YAML.should_receive(:load).with('erb_foo').and_return(config)
  end

  def without_yaml
    File.should_receive(:file?).with('config/pusher.yml').and_return(false)
  end

  describe "configuration" do

    context "via YAML file" do
      context "when credentials are complete" do
        before(:each) do
          with_yaml
        end

        it "is successful" do
          Guard::UI.should_receive(:info).with(/.*Pusher is ready.*/, :reset => true)
          Guard::Pusher.new([])
        end
      end

      context "when credentials are incomplete" do
        before(:each) do
          with_yaml({ 'development' => { 'key' => 'fake_key', 'secret' => 'fake_secret' }})
          Pusher.app_id = nil
        end

        it "issues a warning" do
          Guard::UI.should_receive(:info).with(/.*Pusher not properly configured.*/, :reset => true)
          Guard::Pusher.new([])
        end
      end
    end

    context "via options" do
      context "when credentials are complete" do
        before(:each) do
          without_yaml
        end

        it "is successful" do
          Guard::UI.should_receive(:info).with(/.*Pusher is ready.*/, :reset => true)
          Guard::Pusher.new([], {
            :app_id => 42,
            :key    => 'fake_key',
            :secret => 'fake_secret'
          })
        end
      end

      context "when credentials are incomplete" do
        before(:each) do
          without_yaml
        end

        it "issues a warning" do
          Guard::UI.should_receive(:info).with(/.*Pusher not properly configured.*/, :reset => true)
          Guard::Pusher.new([], {
            :key    => 'fake_key',
            :secret => 'fake_secret'
          })
        end
      end
    end

  end

  describe "options" do
    before(:each) do
      with_yaml
    end

    it ":event" do
      channel = mock(Pusher::Channel)
      Pusher.stub(:[]).and_return(channel)
      channel.should_receive(:trigger).with('custom', { :paths => ['foo'] })
      Guard::Pusher.new([], { :event => 'custom' }).run_on_change(['foo'])
    end
  end

  describe "#run_on_change" do
    it "sends Pusher message" do
      channel = mock(Pusher::Channel)
      Pusher.should_receive(:[]).with('guard-pusher').twice.and_return(channel)
      channel.should_receive(:trigger).with('guard', { :paths => ['foo'] })
      subject.run_on_change(['foo'])
    end
  end

end
