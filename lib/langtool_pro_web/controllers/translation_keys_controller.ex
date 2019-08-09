defmodule LangtoolProWeb.TranslationKeysController do
  use LangtoolProWeb, :controller
  alias LangtoolPro.{TranslationKeys, TranslationKeys.TranslationKey}

  plug :check_auth when action in [:index, :new, :create, :edit, :update, :delete]
  plug :check_confirmation when action in [:index, :new, :create, :edit, :update, :delete]
  plug :find_translation_key when action in [:edit, :update, :delete]

  def index(conn, _) do
    conn
    |> assign(:translation_keys, TranslationKeys.get_translation_keys_for_user(conn.assigns.current_user.id))
    |> render("index.html")
  end

  def new(conn, _) do
    conn
    |> assign(:changeset, TranslationKeys.change_translation_key(%TranslationKey{}))
    |> render("new.html")
  end

  def create(conn, %{"translation_key" => translation_key_params}) do
    translation_key = translation_key_params |> Map.merge(%{"user_id" => conn.assigns.current_user.id}) |> TranslationKeys.create_translation_key()
    case translation_key do
      {:ok, _} ->
        conn
        |> put_flash(:success, "Translation key created successfully.")
        |> redirect(to: translation_keys_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:danger, render_errors(changeset))
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end

  def edit(conn, _) do
    conn
    |> assign(:changeset, TranslationKeys.change_translation_key(conn.assigns.translation_key))
    |> render("edit.html")
  end

  def update(conn, %{"translation_key" => translation_key_params}) do
    case TranslationKeys.update_translation_key(conn.assigns.translation_key, translation_key_params) do
      {:ok, _} ->
        conn
        |> put_flash(:success, "Translation key updated successfully.")
        |> redirect(to: translation_keys_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:danger, "Translation key not updated")
        |> assign(:translation_key, conn.assigns.translation_key)
        |> assign(:changeset, changeset)
        |> render("edit.html")
    end
  end

  def delete(conn, _) do
    TranslationKeys.delete_translation_key(conn.assigns.translation_key)
    conn
    |> put_flash(:success, "Translation key deleted successfully.")
    |> redirect(to: translation_keys_path(conn, :index))
  end

  defp find_translation_key(conn, _) do
    translation_key = conn.params["id"] |> String.to_integer() |> TranslationKeys.get_translation_key()
    case translation_key do
      nil ->
        conn
        |> put_flash(:danger, "Translation key is not found")
        |> redirect(to: translation_keys_path(conn, :index))
        |> halt()
      _ ->
        assign(conn, :translation_key, translation_key)
    end
  end
end
