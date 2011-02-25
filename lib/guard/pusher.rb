require 'guard'
require 'guard/guard'

module Guard
  class Pusher < Guard

    def initialize(watchers = [], options = {})
      super
      Pusher.app_id = options['app_id'] if Pusher.app_id.nil?
      Pusher.key = options['key'] if Pusher.key.nil?
      Pusher.secret = options['secret'] if Pusher.secret.nil?
    end

    def run_on_change(paths)
      Pusher['guard-pusher'].trigger('reload', {})
    end

  end
end
