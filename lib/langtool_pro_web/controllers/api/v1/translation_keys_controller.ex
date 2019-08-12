defmodule LangtoolProWeb.Api.V1.TranslationKeysController do
  use LangtoolProWeb, :controller_api
  alias LangtoolPro.{TranslationKeys}

  plug :api_check_auth
  plug :api_check_confirmation
  plug :find_translation_keys when action in [:index]
  plug :find_translation_key when action in [:update, :delete]
  plug :check_authorize when action in [:update, :delete]

  def index(conn, _) do
    conn
    |> put_status(200)
    |> render("index.json", translation_keys: conn.assigns.translation_keys)
  end

  def create(conn, %{"translation_key" => translation_key_params}) do
    translation_key_params
    |> Map.merge(%{"user_id" => conn.assigns.current_user.id})
    |> TranslationKeys.create_translation_key()
    |> case do
      {:ok, translation_key} ->
        conn
        |> put_status(201)
        |> render("create.json", translation_key: translation_key)
      {:error, %Ecto.Changeset{} = changeset} ->
        render_error(conn, 409, render_errors(changeset))
    end
  end

  def update(conn, %{"translation_key" => translation_key_params}) do
    case TranslationKeys.update_translation_key(conn.assigns.translation_key, translation_key_params) do
      {:ok, translation_key} ->
        conn
        |> put_status(200)
        |> render("update.json", translation_key: translation_key)
      {:error, %Ecto.Changeset{} = changeset} ->
        render_error(conn, 409, render_errors(changeset))
    end
  end

  def delete(conn, _) do
    TranslationKeys.delete_translation_key(conn.assigns.translation_key)
    conn
    |> put_status(200)
    |> render("delete.json")
  end

  defp find_translation_keys(conn, _) do
    assign(conn, :translation_keys, TranslationKeys.get_translation_keys_for_user(conn.assigns.current_user.id))
  end

  defp find_translation_key(conn, _) do
    translation_key = conn.params["id"] |> String.to_integer() |> TranslationKeys.get_translation_key()
    case translation_key do
      nil ->
        conn
        |> render_error(404, "Translation key is not found")
        |> halt()
      _ ->
        assign(conn, :translation_key, translation_key)
    end
  end

  defp check_authorize(conn, _) do
    authorize(conn, :translation_key, :"#{conn.private.phoenix_action}?", conn.assigns.translation_key)
  end
end
