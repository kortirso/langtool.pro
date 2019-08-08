defmodule LangtoolProWeb.TranslationKeysController do
  use LangtoolProWeb, :controller

  plug :check_auth when action in [:index]
  plug :check_confirmation when action in [:index]

  def index(conn, _params) do
    render conn, "index.html"
  end
end
