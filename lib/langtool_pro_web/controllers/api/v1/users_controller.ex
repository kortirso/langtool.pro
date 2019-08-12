defmodule LangtoolProWeb.Api.V1.UsersController do
  use LangtoolProWeb, :controller_api
  alias LangtoolPro.{Users, Mailer}
  alias LangtoolProWeb.{UserMailer}

  def create(conn, %{"user" => user_params}) do
    cond do
      user_params["encrypted_password"] != user_params["password_confirmation"] ->
        render_error(conn, 409, "Passwords are different.")
      true ->
        case Users.create_user(user_params) do
          {:ok, user} ->
            user |> UserMailer.welcome_email() |> Mailer.deliver_later()
            conn
            |> put_status(201)
            |> render("create.json", user: user)
          {:error, changeset} ->
            render_error(conn, 409, render_errors(changeset))
        end
    end
  end
end
