defmodule LangtoolProWeb.PageController do
  use LangtoolProWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
