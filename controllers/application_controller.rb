# encoding: UTF-8
#############################
# controllers/application_controller.rb
#############################
module MyApp
  class ApplicationController < Sinatra::Base
    use Rack::Deflater # gzip
    register Sinatra::CrossOrigin

    helpers Sinatra::JSON

    set :allow_methods, [:get, :post, :delete, :options]

    configure do
      enable :cross_origin
    end

    options '*' do
      halt 200
    end

    not_found do
      status 404
      'not found'
    end

    private

    def persist model, success_status = 200
      if model.save
        status success_status
        json model
      else
        status 400
        json model.errors.messages
      end
    end

    def parsed_json_payload
      request.body.rewind
      @parsed_json_payload = JSON.parse request.body.read
    rescue JSON::ParserError
      halt 400, 'invalid JSON'
    end

    def authenticate!
      user_id, message = Auth.parse_token request.env['HTTP_AUTHORIZATION']
      @current_user = MyApp::User.find_by id: user_id

      handle_unauthorized(message) unless @current_user
    end

    def handle_unauthorized message = nil
      halt 403, "unauthorized:#{message}"
    end
  end
end
