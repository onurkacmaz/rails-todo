# frozen_string_literal: true

class RequestTimer
  def initialize(app)
    @app = app
  end

  def call(env)
    @req = Rack::Request.new(env)

    if should_use_this?
      start_time = Time.now
      status, headers, response = @app.call(env)
      end_time = Time.now

      elapsed_time = (end_time - start_time) * 1000
      Rails.logger.info "Request took #{elapsed_time}ms"

      [status, headers, response]
    else
      @app.call(env)
    end
  end

  def should_use_this?
    @req.path =~ %r{^/tasks}
  end
end
