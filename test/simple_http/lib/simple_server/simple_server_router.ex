defmodule SimpleServer.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger
plug(Plug.Logger, log: :debug)
plug(:match)
plug(:dispatch)


# TODO: add routes!
# Simple GET Request handler for path /hello
get "/hello" do
  send_resp(conn, 200, "hello everyone!")
end


# Basic example to handle POST requests wiht a JSON body
post "/post" do
  {:ok, body, conn} = read_body(conn) 
  body = Poison.decode!(body)
  IO.inspect(body)
  send_resp(conn, 201, "created: #{get_in(body, ["message"])}")
  end



#####  Test ####
get "/download_test_get" do
  send_resp(conn, 200, "hello everyone!")
end


# Basic example to handle POST requests wiht a JSON body
post "/download" do
  {:ok, body, conn} = read_body(conn) 
  body = Poison.decode!(body)
  IO.inspect(body)
  song_name = get_in(body, ["song_name"])
  # if song_name == "crome_yello" do
  song_path = "/root/projects/elixir/Group14Server/audiofiles/audiobooks/crome_yellow_librivox_64kb_mp3/crome_yellow_01_huxley_mac_64kb.mp3"
  send_resp(conn, 201, "song_path: #{song_path}")
  # end
end

##### Test end #####


# "Default" route that will get called when no other route is matched
  match _ do
  send_resp(conn, 404, "not found")
  end
end
