require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'mail'
require 'sqlite3'

configure do

	db = SQLite3::Database.new 'barber.db'

	db.execute 'CREATE TABLE IF NOT EXISTS 
		"Users" 
			("id" INTEGER PRIMARY KEY AUTOINCREMENT, 
			"username" TEXT, 
			"phone" TEXT, 
			"datetime" TEXT, 
			"master" TEXT)'

	db.execute 'CREATE TABLE IF NOT EXISTS 
		"Master" 
			("id" INTEGER PRIMARY KEY AUTOINCREMENT, 
			"master" TEXT)'

 end



get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do

	db = get_db
  @masters = db.execute "SELECT master FROM Master ORDER BY master" # Получаем список мастеров
  db.close

	erb :visit
end

post '/visit' do

	db = get_db
  @masters = db.execute "SELECT master FROM Master ORDER BY master" # Получаем список мастеров
  db.close

	@username = params[:username].capitalize || ''
	@phone = params[:phone] || ''
	@datetime = params[:datetime] || ''
	@master = params[:master] || ''

	input_user = {:username => "Введите имя", :phone => "Введите телефон", :datetime => "Введите дату и время", :master => "Выбирите мастера"}

	input_user.each do |key, value|

		if params[key].to_s.strip.empty?
			@error = input_user[key]
			return erb :visit
		else

		end

	end

	@datetime_formatted = Date.parse(@datetime).strftime("%d.%m.%Y")

	db = get_db

	db.execute 'insert into Users (username, phone, datetime, master) values (?, ?, ?, ?)', [@username, @phone, @datetime_formatted, @master]

	f = File.open "public/user.txt", "a"
	f.write "#{@username}, телефон: #{@phone}, дата и время: #{@datetime_formatted}, мастер #{@master}\n"
	f.close

	@message = "#{@username}, вы успешно записаны на #{@datetime_formatted} к мастеру #{@master}!"

	db.close

	erb :visit

end

get '/contacts' do

	erb :contacts

end

post '/contacts' do

	@username = params[:username]
	@user_email = params[:user_email]
	@user_message = params[:user_message]

	input_user = {:username => "Введите имя", :user_email => "Введите ваш e-mail", :user_message => "Введите ваше сообщение"}

	input_user.each do |key, value|

		if params[key].to_s.strip.empty?
			@error = input_user[key]
			return erb :contacts
		end
	end

  # Настройки SMTP для Mail.ru с двухфакторной аутентификацией
  options = { 
    :address              => "smtp.mail.ru",
    :port                 => 465,
    :domain               => 'mail.ru',
    :user_name            => 'improv00@mail.ru', # Полный email
    :password             => 'wjccbw5YknrbBnw8zfDL', # Пароль из 16 символов
    :authentication       => :login,
    :ssl                  => true,
    :enable_starttls_auto => true
  }

    email_body = <<~BODY
    Новое сообщение из формы контактов:
    
    Имя: #{@username}
    Email: #{@user_email}
    Дата: #{Time.now.strftime('%d.%m.%Y %H:%M')}
    
    Сообщение:
    #{@user_message}
    
    ---
    Это автоматическое сообщение, пожалуйста, не отвечайте на него.
  BODY

  # Формирование и отправка письма с обработкой ошибок
  
    Mail.defaults do
      delivery_method :smtp, options
    end


    Mail.deliver do
      from    'improv00@mail.ru'
      to      'stalker91234@gmail.com'
      subject "Новое сообщение"
      body    email_body
    end

	@message = "Ваше сообщение успешно отправлено!"

	erb :contacts

end

get '/admin' do

	erb :admin

end

post '/admin' do

	@login = params[:login].to_s
	@password = params[:password].to_s

	input_user = {:login => "Введите логин", :password => "Введите пароль"}

	input_user.each do |key, value|

	if params[key].to_s.strip.empty?
			@error = input_user[key]
			return erb :admin
		end
	end

	if @login == "1" && @password == "11"

		 redirect '/showusers' 
	else
		@error = "Неверный логин или пароль!"
		erb :admin
	end

end

get '/showusers' do

  db = get_db
  # Выполняем запрос и получаем результаты
  @users = db.execute "SELECT * FROM Users ORDER BY id DESC"
  db.close

	erb :showusers

end

def get_db
	return SQLite3::Database.new 'barber.db'
end