# Adjusts the SCRIPT_NAME and PATH_INFO so that our app can easily be mounted
# by some upstream proxy.
class BehindProxy
  def initialize(app)
    @app = app
  end

  def call(env)
    if env.has_key?('HTTP_X_SCRIPT_NAME') 
      env['SCRIPT_NAME'] = env['HTTP_X_SCRIPT_NAME']
    end
    @app.call(env)
  end
end


