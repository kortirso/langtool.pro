defmodule LangtoolProWeb.Api.V1.UserTokensController do
  use LangtoolProWeb, :controller_api
  alias LangtoolPro.{Users}
  alias Comeonin.Bcrypt

  def create(conn, %{"email" => email, "password" => password}) do
    user = Users.get_user_by(%{email: email})
    case Bcrypt.check_pass(user, password) do
      {:ok, user} ->
        conn
        |> put_status(201)
        |> render("create.json", user: user)
      {:error, _} ->
        render_error(conn, 409, "Authentification error")
    end
  end
end
