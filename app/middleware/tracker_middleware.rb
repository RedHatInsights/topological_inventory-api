class TrackerMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    dup._call(env)
  end

  def _call(env)
    request_started_on = Time.now
    status, headers, response = @app.call(env)
    request_finished_on = Time.now

    data = {
      :request_duration => (request_finished_on - request_started_on),
      :request_method   => env["REQUEST_METHOD"], # GET, POST, PATCH, etc.
      :request_source   => env["REMOTE_ADDR"],
      :request_uri      => env["REQUEST_URI"], # Path + Query
      :response_code    => status,
    }

    Rails.logger.info(data.inspect)

    [status, headers, response]
  end
end
