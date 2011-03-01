require 'guard'
require 'guard/guard'
require 'pusher'

module Guard
  class Pusher < Guard

    def initialize(watchers = [], options = {})
      super

      @options = options

      config = if File.file?('config/pusher.yml')
        YAML.load_file('config/pusher.yml')['development']
      else
        options
      end

      if config_pusher_with(config)
        UI.info('Pusher is ready.', :reset => true)
      else
        UI.info("D'oh! Pusher not properly configured. Make sure to add app_id, key and secret.", :reset => true)
      end
    end

    def run_on_change(paths)
      ::Pusher['guard-pusher'].trigger(@options[:event] || 'guard', {})
    end


    private

    def config_pusher_with(credentials)
      %w{app_id key secret}.each do |config|
        return false unless (value = credentials[config] || credentials[config.to_sym])
        ::Pusher.send("#{config}=", value)
      end
      true
    end

  end
end
