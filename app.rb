require 'dotenv'
require 'sinatra'
require "sinatra/json"
require 'pusher'

Dotenv.load

client = Pusher::Client.new(
  app_id: ENV["PUSHER_APP_ID"],
  key: ENV["PUSHER_APP_KEY"],
  secret: ENV["PUSHER_APP_SECRET"],
  cluster: ENV["PUSHER_CLUSTER"],
  encrypted: true
)

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/config' do
  json key: ENV["PUSHER_APP_KEY"],
       cluster: ENV["PUSHER_CLUSTER"]
end

# Grant all users access to this channel
post '/pusher/auth' do
  json client.authenticate(params[:channel_name], params[:socket_id], {
    user_id: params[:socket_id]
  })
end

post '/' do
  if ENV["SECRET"] && ENV["SECRET"] != params["SECRET"]
    403
  else

    event = params["submit"]

    # choose a target (maybe they've won something)
    winner = client.channel_users('presence-competition')[:users].sample

    winner ||= {id: "NONE"}

    # trigger event given by submit button
    client.trigger('presence-competition', event, {
      user: winner
    })

    if event == 'noop'
      200
    else
      redirect to("/admin.html?*#{event}* - #{winner["id"]}")
    end

  end
end
