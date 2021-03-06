defmodule LangtoolProWeb.RegistrationController do
  use LangtoolProWeb, :controller
  alias LangtoolPro.{Users, Users.User, Mailer}
  alias LangtoolProWeb.{UserMailer}

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
        # send confirmation email
        user |> UserMailer.welcome_email() |> Mailer.deliver_later()
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:success, "User created successfully.")
        |> redirect(to: complete_path(conn, :complete))
      # error in user creation
      {:error, changeset} ->
        conn
        |> put_flash(:danger, render_errors(changeset))
        |> render("new.html")
    end
  end

  def complete(conn, _) do
    render conn, "complete.html"
  end

  def confirm(conn, %{"email" => email, "confirmation_token" => confirmation_token}) do
    case Users.confirm_user(email, confirmation_token) do
      # successful confirmation
      {:ok, _} ->
        conn
        |> put_flash(:success, "Email confirmed successfully.")
        |> render("confirm.html")
      # failed confirmation
      {:error, message} ->
        conn
        |> put_flash(:danger, message)
        |> render("confirm.html")
    end
  end
end