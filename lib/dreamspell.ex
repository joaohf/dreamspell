defmodule Dreamspell.Application do
  @moduledoc """
  OTP Application for Dreamspell
  """

  use Application

  def start(_type, _args) do
    children = [
      # Use Plug.Cowboy.child_spec/3 to register our endpoint as a plug
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Dreamspell.Endpoint,
        # Set the port per environment, see ./config/MIX_ENV.exs
        options: [port: Application.get_env(:dreamspell, :port)]
      )
    ]

    opts = [strategy: :one_for_one, name: Dreamspell.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule Dreamspell.DreamNotFoundError do
  defexception message: "dream not found"
end

defmodule Dreamspell.Endpoint do
  @moduledoc """
  A Plug responsible for all endpoint operations
  """

  use Plug.Router
  use Plug.ErrorHandler

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  get "/dream" do
    send_resp(conn, 200, "dream!")
  end

  put "/dream" do
    throw(:no_dream)
  end

  post "/dream" do
    raise Dreamspell.DreamNotFoundError
  end

  match _ do
    send_resp(conn, 404, "oops... Nothing here :(")
  end

  def handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    send_resp(conn, conn.status, "Something went wrong")
  end
end
