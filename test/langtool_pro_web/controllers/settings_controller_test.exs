defmodule LangtoolProWeb.SettingsControllerTest do
  use LangtoolProWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/settings"

    assert html_response(conn, 200) =~ "Settings"
  end
end
