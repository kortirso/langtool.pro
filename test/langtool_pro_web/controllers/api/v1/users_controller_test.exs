defmodule LangtoolProWeb.Api.V1.UsersControllerTest do
  use LangtoolProWeb.ConnCase
  alias LangtoolPro.Users

  @user_params %{
    email: "something@gmail.com",
    encrypted_password: "1234567890",
    password_confirmation: "1234567890"
  }

  @different_user_passwords %{
    email: "something@gmail.com",
    encrypted_password: "1",
    password_confirmation: "2"
  }

  @invalid_user_params %{
    email: "something@gmail.com",
    encrypted_password: "",
    password_confirmation: ""
  }

  describe "POST#create" do
    test "different passwords, does not create user", %{conn: conn} do
      users_amount_before = length(Users.get_users)

      conn = post conn, api_users_path(conn, :create), [user: @different_user_passwords]

      assert json_response(conn, 409) == %{"error" => "Passwords are different."}
      assert length(Users.get_users) == users_amount_before
    end

    test "invalid user params, does not create user", %{conn: conn} do
      users_amount_before = length(Users.get_users)

      conn = post conn, api_users_path(conn, :create), [user: @invalid_user_params]

      assert %{"errors" => result} = json_response(conn, 409)
      assert is_list(result)
      assert length(Users.get_users) == users_amount_before
    end

    test "valid user params, creates user", %{conn: conn} do
      users_amount_before = length(Users.get_users)

      conn = post conn, api_users_path(conn, :create), [user: @user_params]

      assert %{"access_token" => access_token, "user" => user} = json_response(conn, 201)
      assert is_binary(access_token)
      assert is_binary(user["email"])
      assert is_integer(user["id"])
      assert is_nil(user["password"])
      assert is_nil(user["encrypted_password"])
      assert length(Users.get_users) == users_amount_before + 1
    end
  end
end
