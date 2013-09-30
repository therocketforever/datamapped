require 'bundler/setup'

Bundler.require :default

configure(:production)  { Bundler.require :production  }
configure(:development) { Bundler.require :development }
configure(:test)        { Bundler.require :test }

DataMapper.setup :default, 'sqlite::memory:'

require File.expand_path('../app', __FILE__)

run Rack::Cascade.new [API, Web]