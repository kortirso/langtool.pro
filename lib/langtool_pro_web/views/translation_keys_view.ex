defmodule LangtoolProWeb.TranslationKeysView do
  use LangtoolProWeb, :view
  alias LangtoolPro.Services

  def service_names do
    Services.list_services |> Enum.map(fn service -> [key: service.name, value: service.id] end)
  end
end
