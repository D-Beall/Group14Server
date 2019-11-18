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
get "/get_song_names" do
  test_string = "Available songs name:
  The Odyssey, The Jungle Book, Crome Yellow"
  send_resp(conn, 200, "#{test_string}")
end

post "/download2" do
  {:ok, body, conn} = read_body(conn) 
  body = Poison.decode!(body)
  IO.inspect(body)
  song_name = get_in(body, ["song_name"])

  {:ok, db} = Sqlitex.open("/root/projects/elixir/Group14Server/elixir_streaming.db")
  {:ok, results} = Sqlitex.query(db, "SELECT * FROM audioinfo WHERE title='#{song_name}'")
  # song_path = List.first(results)[:path] # return a single result
  # item = List.first(results)
  # IO.inspect(item)
  
  return_lst = []
  # res = Poison.encode!(results)
  for item <- results do
    artist = item[:artist]
    dnld_path = item[:path]
    tmp_map = %{artist: artist, dnld_path: dnld_path}
    # IO.inspect(tmp_map)
    return_lst = return_lst ++ [tmp_map]
  end
  song_path = Poison.encode!(return_lst)
  IO.inspect(return_lst)

  # send_resp(conn, 201, "song_path: #{song_path}") # cannot return a dict
  send_resp(conn, 201, song_path) # cannot return a dict
end


# Basic example to handle POST requests wiht a JSON body
post "/download" do
  {:ok, body, conn} = read_body(conn) 
  body = Poison.decode!(body)
  IO.inspect(body)
  song_name = get_in(body, ["song_name"])
  song_path = "http://xzy3.cs.seas.gwu.edu/audiofiles/audiobooks/crome_yellow_librivox_64kb_mp3/crome_yellow_01_huxley_mac_64kb.mp3"
  send_resp(conn, 201, "song_path: #{song_path}")
  # end
end

##### Test end #####


# "Default" route that will get called when no other route is matched
  match _ do
  send_resp(conn, 404, "not found")
  end
end
