defmodule LangtoolProWeb.Api.V1.UserTokensControllerTest do
  use LangtoolProWeb.ConnCase
  import LangtoolPro.Factory

  setup [:create_user]

  describe "POST#create" do
    test "user does not exist", %{conn: conn} do
      conn = post conn, api_user_tokens_path(conn, :create), [email: "", password: ""]

      assert json_response(conn, 409) == %{"error" => "Authentification error"}
    end

    test "invalid auth params", %{conn: conn} do
      conn = post conn, api_user_tokens_path(conn, :create), [email: "something@gmail.com", password: ""]

      assert json_response(conn, 409) == %{"error" => "Authentification error"}
    end

    test "valid auth params", %{conn: conn} do
      conn = post conn, api_user_tokens_path(conn, :create), [email: "something@gmail.com", password: "1234567890"]

      assert %{"access_token" => access_token} = json_response(conn, 201)
      assert is_binary(access_token)
    end
  end

  defp create_user(_) do
    user = insert(:user, email: "something@gmail.com")
    {:ok, user: user}
  end
end
