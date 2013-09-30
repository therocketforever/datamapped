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
    User.first_or_create( :name =>"Nyota Uhura", :number =>"543" )
    User.first_or_create( :name =>"Hikaru Sulu", :number =>"753" )
    User.first_or_create( :name =>"Pavel Chekov", :number =>"795" )
    User.first_or_create( :name =>"Montgomery Scott", :number =>"752" )
    redirect '/'
  end

  get '/inspect' do
    binding.pry
    redirect '/'
  end

end

class API < Grape::API

  #DataMapper.setup :default, 'sqlite::memory:'
  
  version 'api', using: :path, vendor: 'api-provider'
  format :json

  resource :users do
    
    desc "Return the first user in the db."
    get :first do
      @user = User.first
      {:users => [ { :name => @user.name, :number => @user.number } ] }
    end

    desc "Return the last user in the db"
    get :last do
      @user = User.last
      {:users => [ { :name => @user.name, :number => @user.number } ] }
    end

    desc "Return a random user from the db"
    get :random do
      @user = User.all.sample
      {:users => [ { :name => @user.name, :number => @user.number } ] } 
    end

    namespace :users, requirements: { id: /[0-9]*/ } do


      desc "Return a user by Number"
      get :number do
        binding.pry
      end

      desc "Return a user by Name"

      desc "Return a user by ID"
      get :id do
        User.first( :id => params[:id])
      end

    end
    
  end

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