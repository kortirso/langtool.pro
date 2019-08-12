defmodule LangtoolProWeb.Api.V1.UserTokensView do
  use LangtoolProWeb, :view

  def render("create.json", %{user: user}) do
    %{
      access_token: LangtoolPro.Token.encode(user.id)
    }
  end
end