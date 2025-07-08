require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, {adapter: "sqlite3", database: "barbershop.db"}

class Client < ActiveRecord::Base

end

class Barber < ActiveRecord::Base

end

get '/' do 
	@barbers = Barber.all
	erb :index
end

get '/visit' do  

	@barbers = Barber.all
	erb :visit

end

