defmodule SimpleServer.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger
  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(:dispatch)

# "Default" route that will get called when no other route is matched
  get "/get_song_names" do
    test_string = "Available songs name:
  The Odyssey, The Jungle Book, Crome Yellow"
    send_resp(conn, 200, "#{test_string}")
  end

  post "/download" do
    {:ok, body, conn} = read_body(conn)
    body = Poison.decode!(body)
    song_name = get_in(body, ["song_name"])
    artist = get_in(body, "artist")
    {:ok, db} = Sqlitex.open("/root/projects/elixir/Group14Server/elixir_streaming.db")
    {:ok, results} = Sqlitex.query(db, "SELECT * FROM audioinfo WHERE title='#{song_name}' AND artist='#{artist}';")
    res =
      Stream.map(results, fn list ->
        %{artist: list[:artist], title: list[:title], url: list[:path]}
      end)
      |> Poison.encode!()

    send_resp(conn, 200, res)
  end


  # "Default" route that will get called when no other route is matched
  match _ do
    send_resp(conn, 404, "not found")
  end
end

