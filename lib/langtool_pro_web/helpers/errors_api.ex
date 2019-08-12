defmodule LangtoolProWeb.Helpers.ErrorsApi do
  import Plug.Conn
  import Phoenix.Controller

  def render_error(conn, status, message) do
    conn
    |> put_status(status)
    |> put_view(LangtoolProWeb.ErrorView)
    |> render("error.json", message: message)
  end
end
