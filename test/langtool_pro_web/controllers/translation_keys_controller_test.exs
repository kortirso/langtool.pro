defmodule LangtoolProWeb.TranslationKeysControllerTest do
  use LangtoolProWeb.ConnCase
  import LangtoolPro.Factory
  alias LangtoolPro.TranslationKeys

  setup [:create_user]

  @translation_key_params %{
    name: "something",
    value: "1234567890",
    service_id: nil
  }

  @invalid_translation_key_params %{
    name: "something",
    value: "",
    service_id: nil
  }

  describe "GET#index" do
    test "redirects to welcome page for guest", %{conn: conn} do
      conn = get conn, translation_keys_path(conn, :index)

      assert redirected_to(conn) == welcome_path(conn, :index)
      assert get_flash(conn, :danger) == "You need to be signed in to access that page."
    end

    test "redirects to welcome page for unconfirmed user", %{user: user} do
      conn = session_conn() |> put_session(:current_user_id, user.id)
      conn = conn |> get(translation_keys_path(conn, :index))

      assert redirected_to(conn) == welcome_path(conn, :index)
      assert get_flash(conn, :danger) == "You need to confirm your email."
    end

    test "redirects to translation keys page for confirmed user", %{confirmed_user: confirmed_user} do
      conn = session_conn() |> put_session(:current_user_id, confirmed_user.id)
      conn = conn |> get(translation_keys_path(conn, :index))

      assert html_response(conn, 200) =~ "Translation keys"
    end
  end

  describe "GET#new" do
    setup [:create_service]

    test "redirects to welcome page for guest", %{conn: conn} do
      conn = get conn, translation_keys_path(conn, :new)

      assert redirected_to(conn) == welcome_path(conn, :index)
      assert get_flash(conn, :danger) == "You need to be signed in to access that page."
    end

    test "redirects to welcome page for unconfirmed user", %{user: user} do
      conn = session_conn() |> put_session(:current_user_id, user.id)
      conn = conn |> get(translation_keys_path(conn, :new))

      assert redirected_to(conn) == welcome_path(conn, :index)
      assert get_flash(conn, :danger) == "You need to confirm your email."
    end

    test "redirects to new translation key page for confirmed user", %{confirmed_user: confirmed_user} do
      conn = session_conn() |> put_session(:current_user_id, confirmed_user.id)
      conn = conn |> get(translation_keys_path(conn, :new))

      assert html_response(conn, 200) =~ "New translation key"
    end
  end

  describe "POST#create" do
    setup [:create_service]

    test "redirects to welcome page for guest", %{conn: conn} do
      conn = post conn, translation_keys_path(conn, :create), translation_key: %{}

      assert redirected_to(conn) == welcome_path(conn, :index)
      assert get_flash(conn, :danger) == "You need to be signed in to access that page."
    end

    test "redirects to welcome page for unconfirmed user", %{user: user} do
      conn = session_conn() |> put_session(:current_user_id, user.id)
      conn = conn |> post(translation_keys_path(conn, :create), translation_key: %{})

      assert redirected_to(conn) == welcome_path(conn, :index)
      assert get_flash(conn, :danger) == "You need to confirm your email."
    end

    test "does not create translation key for confirmed user and invalid attrs", %{confirmed_user: confirmed_user} do
      translation_keys_amount_before = length(TranslationKeys.get_translation_keys_for_user(confirmed_user.id))

      conn = session_conn() |> put_session(:current_user_id, confirmed_user.id)
      conn = conn |> post(translation_keys_path(conn, :create), translation_key: @invalid_translation_key_params)

      assert html_response(conn, 200) =~ "New translation key"
      assert get_flash(conn, :danger) != nil
      assert length(TranslationKeys.get_translation_keys_for_user(confirmed_user.id)) == translation_keys_amount_before
    end

    test "create translation key for confirmed user and valid attrs", %{confirmed_user: confirmed_user, service: service} do
      translation_keys_amount_before = length(TranslationKeys.get_translation_keys_for_user(confirmed_user.id))

      conn = session_conn() |> put_session(:current_user_id, confirmed_user.id)
      conn = conn |> post(translation_keys_path(conn, :create), translation_key: @translation_key_params |> Map.merge(%{service_id: service.id}))

      assert redirected_to(conn) == translation_keys_path(conn, :index)
      assert get_flash(conn, :success) == "Translation key created successfully."
      assert length(TranslationKeys.get_translation_keys_for_user(confirmed_user.id)) == translation_keys_amount_before + 1
    end
  end

  describe "GET#edit" do
    setup [:create_translation_key]
    setup [:create_service]

    test "redirects to welcome page for guest", %{conn: conn} do
      conn = get conn, translation_keys_path(conn, :edit, "999999")

      assert redirected_to(conn) == welcome_path(conn, :index)
      assert get_flash(conn, :danger) == "You need to be signed in to access that page."
    end

    test "redirects to welcome page for unconfirmed user", %{user: user} do
      conn = session_conn() |> put_session(:current_user_id, user.id)
      conn = conn |> get(translation_keys_path(conn, :edit, "999999"))

      assert redirected_to(conn) == welcome_path(conn, :index)
      assert get_flash(conn, :danger) == "You need to confirm your email."
    end

    test "redirects to translation keys page for confirmed user and unexisted translation key", %{confirmed_user: confirmed_user} do
      conn = session_conn() |> put_session(:current_user_id, confirmed_user.id)
      conn = conn |> get(translation_keys_path(conn, :edit, "999999"))

      assert redirected_to(conn) == translation_keys_path(conn, :index)
      assert get_flash(conn, :danger) == "Translation key is not found"
    end

    test "redirects to welcome page with Forbidden for confirmed user and existed translation key but for other user", %{confirmed_user: confirmed_user, translation_key: translation_key} do
      conn = session_conn() |> put_session(:current_user_id, confirmed_user.id)
      conn = conn |> get(translation_keys_path(conn, :edit, translation_key.id))

      assert redirected_to(conn) == welcome_path(conn, :index)
      assert get_flash(conn, :danger) == "Forbidden."
    end

    test "redirects to edit translation key page for confirmed user and existed translation key", %{confirmed_user: confirmed_user, translation_key: translation_key} do
      translation_key |> TranslationKeys.update_translation_key(%{user_id: confirmed_user.id})

      conn = session_conn() |> put_session(:current_user_id, confirmed_user.id)
      conn = conn |> get(translation_keys_path(conn, :edit, translation_key.id))

      assert html_response(conn, 200) =~ "Edit translation key"
    end
  end

  describe "PATCH#update" do
    setup [:create_translation_key]
    setup [:create_service]

    test "redirects to welcome page for guest", %{conn: conn} do
      conn = patch conn, translation_keys_path(conn, :update, "999999"), translation_key: %{}

      assert redirected_to(conn) == welcome_path(conn, :index)
      assert get_flash(conn, :danger) == "You need to be signed in to access that page."
    end

    test "redirects to welcome page for unconfirmed user", %{user: user} do
      conn = session_conn() |> put_session(:current_user_id, user.id)
      conn = conn |> patch(translation_keys_path(conn, :update, "999999"), translation_key: %{})

      assert redirected_to(conn) == welcome_path(conn, :index)
      assert get_flash(conn, :danger) == "You need to confirm your email."
    end

    test "redirects to translation keys page for confirmed user and unexisted translation key", %{confirmed_user: confirmed_user} do
      conn = session_conn() |> put_session(:current_user_id, confirmed_user.id)
      conn = conn |> patch(translation_keys_path(conn, :update, "999999"), translation_key: %{})

      assert redirected_to(conn) == translation_keys_path(conn, :index)
      assert get_flash(conn, :danger) == "Translation key is not found"
    end

    test "redirects to welcome page with Forbidden for confirmed user and existed translation key but for other user", %{confirmed_user: confirmed_user, translation_key: translation_key} do
      conn = session_conn() |> put_session(:current_user_id, confirmed_user.id)
      conn = conn |> patch(translation_keys_path(conn, :update, translation_key.id), translation_key: %{name: ""})

      assert redirected_to(conn) == welcome_path(conn, :index)
      assert get_flash(conn, :danger) == "Forbidden."
    end

    test "does not update translation key for confirmed user, existed translation key and invalid attrs", %{confirmed_user: confirmed_user, translation_key: translation_key} do
      translation_key |> TranslationKeys.update_translation_key(%{user_id: confirmed_user.id})

      conn = session_conn() |> put_session(:current_user_id, confirmed_user.id)
      conn = conn |> patch(translation_keys_path(conn, :update, translation_key.id), translation_key: %{name: ""})

      assert html_response(conn, 200) =~ "Edit translation key"
      assert get_flash(conn, :danger) == "Translation key not updated"

      object = TranslationKeys.get_translation_key(translation_key.id)

      assert object.name != ""
    end

    test "updates translation key for confirmed user, existed translation key and valid attrs", %{confirmed_user: confirmed_user, translation_key: translation_key} do
      translation_key |> TranslationKeys.update_translation_key(%{user_id: confirmed_user.id})

      conn = session_conn() |> put_session(:current_user_id, confirmed_user.id)
      conn = conn |> patch(translation_keys_path(conn, :update, translation_key.id), translation_key: %{name: "new name"})

      assert redirected_to(conn) == translation_keys_path(conn, :index)
      assert get_flash(conn, :success) == "Translation key updated successfully."

      object = TranslationKeys.get_translation_key(translation_key.id)

      assert object.name == "new name"
    end
  end

  describe "DELETE#delete" do
    setup [:create_translation_key]

    test "redirects to welcome page for guest", %{conn: conn} do
      conn = delete conn, translation_keys_path(conn, :delete, "999999")

      assert redirected_to(conn) == welcome_path(conn, :index)
      assert get_flash(conn, :danger) == "You need to be signed in to access that page."
    end

    test "redirects to welcome page for unconfirmed user", %{user: user} do
      conn = session_conn() |> put_session(:current_user_id, user.id)
      conn = conn |> delete(translation_keys_path(conn, :delete, "999999"))

      assert redirected_to(conn) == welcome_path(conn, :index)
      assert get_flash(conn, :danger) == "You need to confirm your email."
    end

    test "does not delete translation key for confirmed user and unexisted translation key", %{confirmed_user: confirmed_user} do
      conn = session_conn() |> put_session(:current_user_id, confirmed_user.id)
      conn = conn |> delete(translation_keys_path(conn, :delete, "999999"))

      assert redirected_to(conn) == translation_keys_path(conn, :index)
      assert get_flash(conn, :danger) == "Translation key is not found"
    end

    test "redirects to welcome page with Forbidden for confirmed user and existed translation key but for other user", %{confirmed_user: confirmed_user, translation_key: translation_key} do
      conn = session_conn() |> put_session(:current_user_id, confirmed_user.id)
      conn = conn |> delete(translation_keys_path(conn, :delete, translation_key.id))

      assert redirected_to(conn) == welcome_path(conn, :index)
      assert get_flash(conn, :danger) == "Forbidden."
    end

    test "deletes translation key for confirmed user and existed translation key", %{confirmed_user: confirmed_user, translation_key: translation_key} do
      translation_key |> TranslationKeys.update_translation_key(%{user_id: confirmed_user.id})
      translation_keys_amount_before = length(TranslationKeys.get_translation_keys_for_user(confirmed_user.id))

      conn = session_conn() |> put_session(:current_user_id, confirmed_user.id)
      conn = conn |> delete(translation_keys_path(conn, :delete, translation_key.id))

      assert redirected_to(conn) == translation_keys_path(conn, :index)
      assert get_flash(conn, :success) == "Translation key deleted successfully."
      assert length(TranslationKeys.get_translation_keys_for_user(confirmed_user.id)) == translation_keys_amount_before - 1
    end
  end

  defp create_user(_) do
    user = insert(:user)
    confirmed_user = insert(:user) |> confirm()
    {:ok, user: user, confirmed_user: confirmed_user}
  end

  defp create_translation_key(_) do
    translation_key = insert(:translation_key)
    {:ok, translation_key: translation_key}
  end

  defp create_service(_) do
    service = insert(:service)
    {:ok, service: service}
  end
end
