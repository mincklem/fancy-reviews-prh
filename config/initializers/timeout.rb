require RUBY_VERSION < '1.9' && RUBY_PLATFORM != "java" ? 'system_timer' : 'timeout'
SystemTimer ||= Timeout

module Rack
  class Timeout
    @timeout = 30
    @excludes = ['https://limitless-shelf-8981.herokuapp.com/',
    ]

    class << self
      attr_accessor :timeout, :excludes
    end

    def initialize(app)
      @app = app
    end

    def call(env)
      #puts 'BEGIN CALL'
      #puts  env['REQUEST_URI']
      #puts 'END CALL'

      if self.class.excludes.any? {|exclude_uri| /#{exclude_uri}/ =~ env['REQUEST_URI']}
        @app.call(env)
      else
        SystemTimer.timeout(self.class.timeout, ::Timeout::Error) { @app.call(env) }
      end
    end

  end
end