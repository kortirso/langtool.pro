defmodule LangtoolProWeb.SettingsControllerTest do
  use LangtoolProWeb.ConnCase
  import LangtoolPro.Factory

  setup [:create_user]

  describe "GET#index" do
    test "for guest", %{conn: conn} do
      conn = get conn, "/settings"

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :danger) == "You need to be signed in to access that page."
    end

    test "for unconfirmed user", %{user: user} do
      conn = session_conn() |> put_session(:current_user_id, user.id) |> get("/settings")

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :danger) == "You need to confirm your email."
    end

    test "for confirmed user", %{confirmed_user: confirmed_user} do
      conn = session_conn() |> put_session(:current_user_id, confirmed_user.id) |> get("/settings")

      assert html_response(conn, 200) =~ "Settings"
    end
  end

  defp create_user(_) do
    user = insert(:user)
    confirmed_user = insert(:user) |> confirm()
    {:ok, user: user, confirmed_user: confirmed_user}
  end
end
