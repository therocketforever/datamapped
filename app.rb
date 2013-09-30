#DataMapper.setup(:default, "sqlite://#{Dir.pwd}/development.db")
#DataMapper.setup :default, 'sqlite::memory:'

class Web < Sinatra::Base

  #configure(:development) { DataMapper.setup :default, 'sqlite::memory:' }

  get '/' do
    @user = User.first unless User.all.empty? unless @user
    if @user then "Hello #{@user.name}! Your number is #{@user.number}." else redirect '/init' end
  end

  get '/init' do
    User.first_or_create( :name =>"Jim Kirk", :number =>"123" )
    User.first_or_create( :name =>"Lenord McCoy", :number =>"456" )
    User.first_or_create( :name =>"Spock", :number =>"789" )
    redirect '/'
  end

  get '/inspect' do
    binding.pry
    redirect '/'
  end

end

class API < Grape::API

  #DataMapper.setup :default, 'sqlite::memory:'
  
  namespace :users do
    
    get '/:id' do
      User.get params[:id]
    end
  
  end

end

class User
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  property :number, Integer #, reader: :protected

end

DataMapper.finalize.auto_migrate!