defmodule LangtoolProWeb.Api.V1.TasksView do
  use LangtoolProWeb, :view

  def render("detection.json", %{message: message}), do: message
end