#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'pony'
require 'sinatra/reloader'
require 'sqlite3'

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visits' do
	erb :visits
end

post '/visits' do
	@customername = params[:username]
	@phonenumber = params[:phonenumber]
	@datatime = params[:datatime]
	@specialist = params[:spec]
	@color = params[:color]
	hh_err={
		username:'Type your name',
		phonenumber: 'Type your phonenumber',
		datatime: 'Type your datatime'}
	
		@error = is_the_params_empty hh_err, params
			if @error == ''	
				tobase params
				tofile "#{@customername} will come at #{@datatime}. #{@specialist} can contact him by #{@phonenumber}. Print in #{@color} \n" , "visitors_list"
				@welcomecustomer = "Dear  #{@customername}, #{@specialist} will happy to see you at #{@datatime}, and print in #{@color}"
				erb :visits 
			else
				erb :visits
			end
end

get '/contacts' do
	erb :contacts
end

post '/contacts' do
	@email=params[:email]
	@message=params[:message]
	@customername=params[:username]

	hh={
		username: 'Type your name'	,
		email: 'Type your email',
		message: 'Type your message'
	}

	@error = is_the_params_empty hh,params
			if @error == ''	
				@welcomecustomer = "Thank you Dear #{@customername} fore mail us!"

				 Pony.mail(
			      to: 'sinikit@yahoo.com',
			      from: @message ,
			      subject: "#{@customername} has contacted you",
			      body: @message
			     )

				else
				erb :visits
			end


	erb :contacts
end


def tofile userdata ,  file_name
	f=File.open("./public/#{file_name}.txt", "a")
	f.print userdata
	f.close
end

def tobase date
	db = SQLite3::Database.new './public/databasse/barbershop.sqlite'
	db.execute "INSERT INTO Users (Name,
								   phone,
								   datestamp,
								   barber,
								   color) VALUES 
								   ('#{date[:username]}',
								   '#{date[:phonenumber]}',
								   '#{date[:datatime]}',
								   '#{date[:spec]}',
								   '#{date[:color]}')"
	db.close

end

def is_the_params_empty hh, params
	result=''
	hh.each do |key, value|
		if params[key]==''
			result<<hh[key]<<' '
		end		
	end
	return result
end

