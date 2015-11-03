class ProjectController < Sinatra::Base
  get '/' do
    content_type :json
    "This is the project root"
  end
end
