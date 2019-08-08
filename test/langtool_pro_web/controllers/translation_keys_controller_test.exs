defmodule LangtoolProWeb.TranslationKeysControllerTest do
  use LangtoolProWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/translation_keys"

    assert html_response(conn, 200) =~ "Translation keys"
  end
end
