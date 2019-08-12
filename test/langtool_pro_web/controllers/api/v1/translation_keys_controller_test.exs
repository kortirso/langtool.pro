defmodule LangtoolProWeb.Api.V1.TranslationKeysControllerTest do
  use LangtoolProWeb.ConnCase
  import LangtoolPro.Factory
  alias LangtoolPro.{TranslationKeys, Token}

  setup [:create_user]

  @translation_key_params %{
    name: "something",
    service: "yandex",
    value: "1234567890"
  }

  @invalid_translation_key_params %{
    name: "something",
    service: "",
    value: ""
  }

  describe "GET#index" do
    test "renders auth error for guest without token", %{conn: conn} do
      conn = get conn, api_translation_keys_path(conn, :index)

      assert json_response(conn, 401) == %{"error" => "There is no authorization token in headers"}
    end

    test "renders auth error for user with invalid token", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "1234567890")
        |> get(api_translation_keys_path(conn, :index))

      assert json_response(conn, 401) == %{"error" => "Invalid token"}
    end

    test "renders auth error for unconfirmed user", %{conn: conn, user: user} do
      conn =
        conn
        |> put_req_header("authorization", Token.encode(user.id))
        |> get(api_translation_keys_path(conn, :index))

      assert json_response(conn, 401) == %{"error" => "Unconfirmed email"}
    end

    test "returns data for success", %{conn: conn, confirmed_user: confirmed_user} do
      conn =
        conn
        |> put_req_header("authorization", Token.encode(confirmed_user.id))
        |> get(api_translation_keys_path(conn, :index))

      assert %{"translation_keys" => translation_keys} = json_response(conn, 200)
    end
  end

  describe "POST#create" do
    test "renders auth error for guest without token", %{conn: conn} do
      conn = post conn, api_translation_keys_path(conn, :create), translation_key: %{}

      assert json_response(conn, 401) == %{"error" => "There is no authorization token in headers"}
    end

    test "renders auth error for user with invalid token", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "1234567890")
        |> post(api_translation_keys_path(conn, :create), translation_key: %{})

      assert json_response(conn, 401) == %{"error" => "Invalid token"}
    end

    test "renders auth error for unconfirmed user", %{conn: conn, user: user} do
      conn =
        conn
        |> put_req_header("authorization", Token.encode(user.id))
        |> post(api_translation_keys_path(conn, :create), translation_key: %{})

      assert json_response(conn, 401) == %{"error" => "Unconfirmed email"}
    end

    test "does not create translation keys for invalid params", %{conn: conn, confirmed_user: confirmed_user} do
      translation_keys_amount_before = length(TranslationKeys.get_translation_keys_for_user(confirmed_user.id))

      conn =
        conn
        |> put_req_header("authorization", Token.encode(confirmed_user.id))
        |> post(api_translation_keys_path(conn, :create), translation_key: @invalid_translation_key_params)

      assert %{"errors" => errors} = json_response(conn, 409)
      assert is_list(errors)
      assert length(TranslationKeys.get_translation_keys_for_user(confirmed_user.id)) == translation_keys_amount_before
    end

    test "creates translation keys for valid params", %{conn: conn, confirmed_user: confirmed_user} do
      translation_keys_amount_before = length(TranslationKeys.get_translation_keys_for_user(confirmed_user.id))

      conn =
        conn
        |> put_req_header("authorization", Token.encode(confirmed_user.id))
        |> post(api_translation_keys_path(conn, :create), translation_key: @translation_key_params)

      assert %{"translation_key" => result} = json_response(conn, 201)
      assert %{
                "id" => id,
                "name" => "something",
                "service" => "yandex",
                "value" => "1234567890"
              } = result
      assert length(TranslationKeys.get_translation_keys_for_user(confirmed_user.id)) == translation_keys_amount_before + 1
    end
  end

  describe "PATCH#update" do
    setup [:create_translation_key]

    test "renders auth error for guest without token", %{conn: conn} do
      conn = patch conn, api_translation_keys_path(conn, :update, "999999"), translation_key: %{}

      assert json_response(conn, 401) == %{"error" => "There is no authorization token in headers"}
    end

    test "renders auth error for user with invalid token", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "1234567890")
        |> patch(api_translation_keys_path(conn, :update, "999999"), translation_key: %{})

      assert json_response(conn, 401) == %{"error" => "Invalid token"}
    end

    test "renders auth error for unconfirmed user", %{conn: conn, user: user} do
      conn =
        conn
        |> put_req_header("authorization", Token.encode(user.id))
        |> patch(api_translation_keys_path(conn, :update, "999999"), translation_key: %{})

      assert json_response(conn, 401) == %{"error" => "Unconfirmed email"}
    end

    test "renders auth error for confirmed user but translation key of other user", %{conn: conn, confirmed_user: confirmed_user, translation_key: translation_key} do
      conn =
        conn
        |> put_req_header("authorization", Token.encode(confirmed_user.id))
        |> patch(api_translation_keys_path(conn, :update, translation_key.id), translation_key: %{})

      assert json_response(conn, 401) == %{"error" => "Forbidden"}
    end

    test "renders auth error for confirmed user but for unexisted translation key", %{conn: conn, confirmed_user: confirmed_user, translation_key: translation_key} do
      translation_key |> TranslationKeys.update_translation_key(%{user_id: confirmed_user.id})

      conn =
        conn
        |> put_req_header("authorization", Token.encode(confirmed_user.id))
        |> delete(api_translation_keys_path(conn, :delete, "999999"))

      assert json_response(conn, 404) == %{"error" => "Translation key is not found"}
    end

    test "does not update translation keys for invalid params", %{conn: conn, confirmed_user: confirmed_user, translation_key: translation_key} do
      translation_key |> TranslationKeys.update_translation_key(%{user_id: confirmed_user.id})

      conn =
        conn
        |> put_req_header("authorization", Token.encode(confirmed_user.id))
        |> patch(api_translation_keys_path(conn, :update, translation_key.id), translation_key: %{name: ""})

      assert %{"errors" => errors} = json_response(conn, 409)
      assert is_list(errors)

      object = TranslationKeys.get_translation_key(translation_key.id)

      assert object.name != ""
    end

    test "update translation keys for valid params", %{conn: conn, confirmed_user: confirmed_user, translation_key: translation_key} do
      translation_key |> TranslationKeys.update_translation_key(%{user_id: confirmed_user.id})

      conn =
        conn
        |> put_req_header("authorization", Token.encode(confirmed_user.id))
        |> patch(api_translation_keys_path(conn, :update, translation_key.id), translation_key: %{name: "new name"})

      assert %{"translation_key" => result} = json_response(conn, 200)
      assert result == %{
                          "id" => translation_key.id,
                          "name" => "new name",
                          "service" => translation_key.service,
                          "value" => translation_key.value
                        }

      object = TranslationKeys.get_translation_key(translation_key.id)

      assert object.name == "new name"
    end
  end

  describe "DELETE#delete" do
    setup [:create_translation_key]

    test "renders auth error for guest without token", %{conn: conn} do
      conn = delete conn, api_translation_keys_path(conn, :delete, "999999")

      assert json_response(conn, 401) == %{"error" => "There is no authorization token in headers"}
    end

    test "renders auth error for user with invalid token", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "1234567890")
        |> delete(api_translation_keys_path(conn, :delete, "999999"))

      assert json_response(conn, 401) == %{"error" => "Invalid token"}
    end

    test "renders auth error for unconfirmed user", %{conn: conn, user: user} do
      conn =
        conn
        |> put_req_header("authorization", Token.encode(user.id))
        |> delete(api_translation_keys_path(conn, :delete, "999999"))

      assert json_response(conn, 401) == %{"error" => "Unconfirmed email"}
    end

    test "renders auth error for confirmed user but translation key of other user", %{conn: conn, confirmed_user: confirmed_user, translation_key: translation_key} do
      conn =
        conn
        |> put_req_header("authorization", Token.encode(confirmed_user.id))
        |> delete(api_translation_keys_path(conn, :delete, translation_key.id))

      assert json_response(conn, 401) == %{"error" => "Forbidden"}
    end

    test "renders auth error for confirmed user but for unexisted translation key", %{conn: conn, confirmed_user: confirmed_user, translation_key: translation_key} do
      translation_key |> TranslationKeys.update_translation_key(%{user_id: confirmed_user.id})

      conn =
        conn
        |> put_req_header("authorization", Token.encode(confirmed_user.id))
        |> delete(api_translation_keys_path(conn, :delete, "999999"))

      assert json_response(conn, 404) == %{"error" => "Translation key is not found"}
    end

    test "deletes translation key for confirmed user and existed translation key", %{conn: conn, confirmed_user: confirmed_user, translation_key: translation_key} do
      translation_key |> TranslationKeys.update_translation_key(%{user_id: confirmed_user.id})
      translation_keys_amount_before = length(TranslationKeys.get_translation_keys_for_user(confirmed_user.id))

      conn =
        conn
        |> put_req_header("authorization", Token.encode(confirmed_user.id))
        |> delete(api_translation_keys_path(conn, :delete, translation_key.id))

      assert %{"success" => "Translation key is destroyed"} = json_response(conn, 200)
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
end
