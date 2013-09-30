DataMapper.setup :default, 'sqlite::memory:'

class User
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :number, Integer, reader: :protected
end

DataMapper.finalize.auto_migrate!

class Web < Sinatra::Base


  get '/' do
    puts "Hello world."
    binding.pry
  end
end

class API < Grape::API
  namespace :users do
    get '/:id' do
      User.get params[:id]
    end
  end
end

binding.pry