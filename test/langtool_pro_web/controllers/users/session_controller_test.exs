defmodule LangtoolProWeb.SessionControllerTest do
  use LangtoolProWeb.ConnCase
  import LangtoolPro.Factory

  setup [:create_user]

  describe "GET#new" do
    test "GET /signin", %{conn: conn} do
      conn = get conn, "/signin"

      assert html_response(conn, 200) =~ "Welcome back!"
    end
  end

  describe "POST#create" do
    test "unexisted user", %{conn: conn} do
      conn = post conn, "/signin", [session: %{email: "", password: ""}]

      assert html_response(conn, 200) =~ "Welcome back!"
      assert get_flash(conn, :danger) == "Invalid credentials."
    end

    test "existed user, invalid credentials", %{conn: conn, user: user} do
      conn = post conn, "/signin", [session: %{email: user.email, password: ""}]

      assert html_response(conn, 200) =~ "Welcome back!"
      assert get_flash(conn, :danger) == "Invalid credentials."
    end

    test "existed user, valid credentials", %{conn: conn, user: user} do
      conn = post conn, "/signin", [session: %{email: user.email, password: "1234567890"}]

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :success) == "Signed in successfully."
    end
  end

  describe "DELETE#delete" do
    test "existed user, valid credentials", %{conn: conn} do
      conn = delete conn, "/signout"

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :success) == "Signed out successfully."
    end
  end

  defp create_user(_) do
    user = insert(:user)
    {:ok, user: user}
  end
end
