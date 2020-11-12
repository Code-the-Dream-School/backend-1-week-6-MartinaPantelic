require "sinatra"
require "sinatra/reloader"

enable :sessions

def guessed_number
  session[:number]
end

def secret_number
  session[:secret]
end

def answers_remain
  7 - session[:counter]
end

def background
  session[:background]
end

def guess_case
  session[:background] = "#fff"
  if guessed_number > secret_number
    result = guessed_number - secret_number
    if result <= 10
      descript = "close but too high"
      session[:background] = "#ffaaaa"
    else result > 10
      descript = "much too high"
      puts "answers remain#{answers_remain}"
      session[:background] = "#ff4444"     end
  elsif guessed_number < secret_number
    result = secret_number - guessed_number
    if result <= 10
      descript = "close but too low"
      session[:background] = "#ffaaaa"
    else result > 10
      descript = "much too low"
      session[:background] = "#ff4444"     end
  end

  puts "Your guess of #{guessed_number} was #{descript}."
  session[:message] = "#{guessed_number} is #{descript}. You have #{answers_remain} remainig attempts. Try Again!"
end

get "/" do
  session[:secret] = rand(100) + 1
  session[:counter] = 0
  session[:message] = ""
  session[:background] = "#fff"
  erb :form
end

post "/" do
  session[:number] = params[:number].to_i if params[:number]
  session[:counter] += 1
  if session[:number] == session[:secret]
    session[:background] = "#c4f6ff"
    erb :win_message
  elsif session[:counter] >= 7
    session[:background] = "#000"
    erb :lose_message
  else
    session[:background] = "#fff"
    guess_case
    session[:message]
    erb :form
  end
end
