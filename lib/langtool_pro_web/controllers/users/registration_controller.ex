defmodule LangtoolProWeb.RegistrationController do
  use LangtoolProWeb, :controller
  alias LangtoolPro.{Users, Users.User}

  def new(conn, _) do
    changeset = Users.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    cond do
      # password are different
      user_params["encrypted_password"] != user_params["password_confirmation"] ->
        conn
        |> put_flash(:danger, "Passwords are different.")
        |> render("new.html")
      # password are the same
      true ->
        do_create(conn, user_params)
    end
  end

  defp do_create(conn, user_params) do
    case Users.create_user(user_params) do
      # user is created
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:success, "User created successfully.")
        |> redirect(to: welcome_path(conn, :index))
      # error in user creation
      {:error, changeset} ->
        conn
        |> put_flash(:danger, render_errors(changeset))
        |> render("new.html")
    end
  end
end