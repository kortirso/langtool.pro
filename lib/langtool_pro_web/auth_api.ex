defmodule LangtoolProWeb.AuthApi do
  @moduledoc """
  A module providing api auth functions
  """

  alias LangtoolPro.{Users}

  defmacro __using__(_opts) do
    quote do
      defp api_check_auth(%Plug.Conn{req_headers: req_headers} = conn, _) do
        case Enum.find(req_headers, fn {key, value} -> key == "authorization" end) do
          {_, authorization_token} -> do_decode_token(conn, authorization_token)
          _ -> render_api_auth_error(conn, "There is no authorization token in headers")
        end
      end

      defp do_decode_token(conn, authorization_token) do
        case LangtoolPro.Token.decode(authorization_token) do
          %{"user_id" => user_id} -> do_find_user(conn, user_id)
          _ -> render_api_auth_error(conn, "Invalid token")
        end
      end

      defp do_find_user(conn, user_id) do
        case Users.get_user(user_id) do
          nil -> render_api_auth_error(conn, "User is not found")
          current_user -> assign(conn, :current_user, current_user)
        end
      end

      defp api_check_confirmation(conn, _) do
        if conn.assigns.current_user.confirmed_at == nil do
          render_api_auth_error(conn, "Unconfirmed email")
        else
          conn
        end
      end

      defp render_api_auth_error(conn, message) do
        conn
        |> render_error(401, message)
        |> halt()
      end
    end
  end
end
