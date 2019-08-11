defmodule LangtoolProWeb.Api.V1.UsersView do
  use LangtoolProWeb, :view

  def render("create.json", %{user: user}) do
    %{
      user: user_json(user),
      access_token: LangtoolPro.Token.encode(user.id)
    }
  end

  defp user_json(user) do
    %{
      id: user.id,
      email: user.email
    }
  end
end