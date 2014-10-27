module Moi
  class GitShaMiddleware
    def initialize(app, sha)
      @app, @sha = app, sha
    end

    def call(env)
      code, headers, response = @app.call(env)
      headers['Git-SHA'] = @sha
      [code, headers, response]
    end
  end
end
