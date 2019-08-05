defmodule LangtoolProWeb.RegistrationControllerTest do
  use LangtoolProWeb.ConnCase
  import LangtoolPro.Factory
  alias LangtoolPro.Users

  setup [:create_user]

  @user_params %{
    email: "something@gmail.com",
    encrypted_password: "1234567890",
    password_confirmation: "1234567890",
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

  describe "GET#new" do
    test "GET /signup", %{conn: conn} do
      conn = get conn, "/signup"

      assert html_response(conn, 200) =~ "Join LangTool"
    end
  end

  describe "POST#create" do
    test "different passwords, does not create user", %{conn: conn} do
      users_amount_before = length(Users.get_users)

      conn = post conn, "/registration", [user: @different_user_passwords]

      assert html_response(conn, 200) =~ "Join LangTool"
      assert get_flash(conn, :danger) == "Passwords are different."
      assert length(Users.get_users) == users_amount_before
    end

    test "invalid user params, does not create user", %{conn: conn} do
      users_amount_before = length(Users.get_users)

      conn = post conn, "/registration", [user: @invalid_user_params]

      assert html_response(conn, 200) =~ "Join LangTool"
      assert get_flash(conn, :danger) == ["Password can't be blank"]
      assert length(Users.get_users) == users_amount_before
    end

    test "valid user params, creates user", %{conn: conn} do
      users_amount_before = length(Users.get_users)

      conn = post conn, "/registration", [user: @user_params]

      assert redirected_to(conn) == "/registration/complete"
      assert get_flash(conn, :success) == "User created successfully."
      assert length(Users.get_users) == users_amount_before + 1
    end
  end

  describe "GET#complete" do
    test "GET /registration/complete", %{conn: conn} do
      conn = get conn, "/registration/complete"

      assert html_response(conn, 200) =~ "Thank you for registration"
    end
  end

  describe "GET#confirm" do
    test "unexisted user", %{conn: conn} do
      conn = get conn, "/registration/confirm", [email: "", confirmation_token: ""]

      assert get_flash(conn, :danger) == "User is not found for confirmation"
    end

    test "existed user, invalid confirmation token", %{conn: conn, user: user} do
      conn = get conn, "/registration/confirm", [email: user.email, confirmation_token: ""]

      assert get_flash(conn, :danger) == "Confirmation token is invalid"
    end

    test "existed user, valid confirmation token", %{conn: conn, user: user} do
      conn = get conn, "/registration/confirm", [email: user.email, confirmation_token: user.confirmation_token]

      assert get_flash(conn, :success) == "Email confirmed successfully."
    end
  end

  defp create_user(_) do
    user = insert(:user)
    {:ok, user: user}
  end
end
