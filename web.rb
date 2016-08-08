require "sinatra"
require 'haml'
require_relative "mastermind"
require "sinatra/reloader" if development?
#when you go to the root of this app, the only thing this should do is render the template.

$play = MasterMind.new

get "/" do
  haml :index
end

post "/guess" do
  user_guess = params["color1"], params["color2"], params["color3"], params["color4"]
  results = $play.guess(user_guess)

  if $play.guess_count > 10
    redirect "/lose"
    return
  end

  if $play.result_win?(results)
    redirect "/win"
  end

  redirect "/"
end

get "/lose" do
  haml :lose
end

get "/win" do
  haml :win
end

post "/restart" do
  $play = MasterMind.new
  redirect "/"
end
