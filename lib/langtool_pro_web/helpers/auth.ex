defmodule LangtoolProWeb.Helpers.Auth do
  alias LangtoolPro.{Repo, Users.User}

  def signed_in?(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    if user_id, do: !!Repo.get(User, user_id)
  end
end
