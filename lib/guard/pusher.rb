require 'guard'
require 'guard/guard'
require 'pusher'

module Guard
  class Pusher < Guard

    def initialize(watchers = [], options = {})
      super
      [ :app_id, :key, :secret ].each { |attr|
        ::Pusher.send("#{attr}=", options[attr]) unless ::Pusher.send("#{attr}")
      }
    end

    def run_on_change(paths)
      ::Pusher['guard-pusher'].trigger('reload', {})
    end

  end
end
