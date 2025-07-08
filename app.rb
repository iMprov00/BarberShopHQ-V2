require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, {adapter: "sqlite3", database: "barbershop.db"}

class Client < ActiveRecord::Base

	validates :name, presence: true
	validates :phone, presence: true
	validates :datestamp, presence: true
	validates :color, presence: true

end

class Barber < ActiveRecord::Base

end

get '/' do 

	@barbers = Barber.all
	erb :index
end

get '/visit' do  
	@c = Client.new params[:client] 
	@barbers = Barber.all
	erb :visit

end

post '/visit' do  

	@c = Client.new params[:client]
	if @c.save
		erb "Вы записались!"
	else
		@error = @c.errors.full_messages.first
		erb :visit
	end

end

get '/barber/:id' do 

	@barber = Barber.find(params[:id])

	

	erb :barber

end

