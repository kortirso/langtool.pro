defmodule LangtoolProWeb.PageControllerTest do
  use LangtoolProWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, welcome_path(conn, :index)

    assert html_response(conn, 200) =~ "LangTool!"
  end
end
