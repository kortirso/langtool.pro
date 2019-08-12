defmodule LangtoolProWeb.Api.V1.TranslationKeysView do
  use LangtoolProWeb, :view

  def render("index.json", %{translation_keys: translation_keys}) do
    %{
      translation_keys: Enum.map(translation_keys, &translation_key_json/1)
    }
  end

  def render("create.json", %{translation_key: translation_key}) do
    %{
      translation_key: translation_key_json(translation_key)
    }
  end

  def render("update.json", %{translation_key: translation_key}) do
    %{
      translation_key: translation_key_json(translation_key)
    }
  end

  def render("delete.json", %{}) do
    %{
      success: "Translation key is destroyed"
    }
  end

  defp translation_key_json(translation_key) do
    %{
      id: translation_key.id,
      name: translation_key.name,
      service: translation_key.service,
      value: translation_key.value
    }
  end
end