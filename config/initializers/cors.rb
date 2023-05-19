# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: [:get, :post, :patch, :put, :delete]
    end
  end

Rails.application.config.hosts << "https://editor.swagger.io/"
Rails.application.config.hosts << "app-asw-api.fly.dev"