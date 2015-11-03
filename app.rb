# encoding: UTF-8
#############################
# app.rb
#############################
require 'rubygems'
require 'bundler'

Bundler.require

require_all 'models', 'controllers', 'lib'

Dotenv.load

module MyApp
  class App < Sinatra::Base
  	use ApplicationController
    use ProjectController
  end
end
