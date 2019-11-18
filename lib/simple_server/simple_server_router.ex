defmodule SimpleServer.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger
plug(Plug.Logger, log: :debug)
plug(:match)
plug(:dispatch)


get "/get_song_names" do
  test_string = "Available songs name:
  The Odyssey, The Jungle Book, Crome Yellow"
  send_resp(conn, 200, "#{test_string}")
end


post "/download" do
  {:ok, body, conn} = read_body(conn) 
  body = Poison.decode!(body)
  IO.inspect(body)
  song_name = get_in(body, ["song_name"])

  {:ok, db} = Sqlitex.open("/root/projects/elixir/Group14Server/elixir_streaming.db")
  {:ok, results} = Sqlitex.query(db, "SELECT * FROM audioinfo WHERE title='#{song_name}'")
  res = Stream.map(results, fn list -> %{artist: list[:artist], title: list[:title], url: list[:path]} end) |> Poison.encode!

  send_resp(conn, 201, res)
end

# "Default" route that will get called when no other route is matched
  match _ do
  send_resp(conn, 404, "not found")
  end
end
