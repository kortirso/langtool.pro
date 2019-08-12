defmodule LangtoolProWeb.SessionController do
  use LangtoolProWeb, :controller
  alias LangtoolPro.Users
  alias Comeonin.Bcrypt

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => session}) do
    user = Users.get_user_by(%{email: session["email"]})
    case Bcrypt.check_pass(user, session["password"]) do
      # successful signin
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:success, "Signed in successfully.")
        |> redirect(to: welcome_path(conn, :index))
      # signin error
      _ ->
        conn
        |> put_flash(:danger, "Invalid credentials.")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:success, "Signed out successfully.")
    |> redirect(to: welcome_path(conn, :index))
  end
end