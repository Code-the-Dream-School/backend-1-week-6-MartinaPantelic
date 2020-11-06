require "sinatra"
require "sinatra/reloader"

@@secret_number = rand(101)
@@remaining_guesses = 7
message = "Guess a secret number between 0 and 100!"
end_message = ""
@@result_msg_low = "Too low."
@@result_msg_very_low = "Way too low!"
@@result_msg_high = "Too high."
@@result_msg_very_high = "Way too high!"
# end_message_lost = "LOST"
background = ""

get "/" do
  erb :index, :locals => { :number => @@secret_number,
                           :message => message,
                           :end_message => end_message,
                           :background => background,
                           :remaining => @@remaining_guesses }

  if params["guess"] != nil
    end_message = ""
    guess_int = params["guess"].to_i
    message = check_guess(guess_int)
    background = check_message(message)
    @@remaining_guesses -= 1
    if @@remaining_guesses == 0 || message == "Yes! The secret number is #{@@secret_number}"
      if message != "Yes! The secret number is #{@@secret_number}"
        end_message = "You lose. The secret number has changed."
        background = "#eee"
      end
      if message == "Yes! The secret number is #{@@secret_number}"
        end_message = "Play again!"
      end
      @@remaining_guesses = 7
      @@secret_number = rand(101)
    end
  end
  erb :index, :locals => { :number => @@secret_number,
                           :guess => guess_int,
                           :message => message,
                           :end_message => end_message,
                           :background => background,
                           :remaining => @@remaining_guesses }
end

def check_guess(guess)
  if guess == @@secret_number
    "Yes! The secret number is #{@@secret_number}"
  elsif guess < @@secret_number
    if guess < @@secret_number - 10
      @@result_msg_very_low
    else
      @@result_msg_low
    end
  elsif guess > @@secret_number
    if guess > @@secret_number + 10
      @@result_msg_very_high
    else
      @@result_msg_high
    end
  end
end

def check_message(message)
  case message
  when "Yes! The secret number is #{@@secret_number}" then "#BCF5A9"
  when @@result_msg_very_high then "#ff4444"
  when @@result_msg_high then "#ffaaaa"
  when @@result_msg_very_low then "#ff4444"
  when @@result_msg_low then "#ffaaaa"
  else "white"
  end
end
