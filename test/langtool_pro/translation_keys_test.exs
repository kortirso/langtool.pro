defmodule LangtoolPro.TranslationKeysTest do
  use LangtoolProWeb.ConnCase
  import LangtoolPro.Factory
  alias LangtoolPro.{TranslationKeys, TranslationKeys.TranslationKey}

  setup [:create_translation_keys]

  @translation_key_params %{
    name: "Key",
    value: "some_value",
    service_id: nil
  }

  @invalid_translation_key_params %{
    name: "Key",
    value: "",
    service_id: nil
  }

  describe ".get_translation_keys_for_user" do
    test "returns translation_key for existed id", %{translation_key1: translation_key1} do
      result = TranslationKeys.get_translation_keys_for_user(translation_key1.user_id)

      assert length(result) == 1
      assert Enum.at(result, 0).id == translation_key1.id
    end

    test "returns [] for user without keys", %{translation_key1: translation_key1, translation_key2: translation_key2} do
      assert [] == TranslationKeys.get_translation_keys_for_user(translation_key1.user_id + translation_key2.user_id)
    end
  end

  describe ".get_translation_key" do
    test "returns translation_key for existed id", %{translation_key1: translation_key1} do
      assert translation_key1.id == TranslationKeys.get_translation_key(translation_key1.id).id
    end

    test "returns nil for unexisted id", %{translation_key1: translation_key1, translation_key2: translation_key2} do
      assert nil == TranslationKeys.get_translation_key(translation_key1.id + translation_key2.id)
    end
  end

  describe ".get_translation_key_by" do
    test "returns translation_key for existed params", %{translation_key1: translation_key1} do
      assert translation_key1.id == TranslationKeys.get_translation_key_by(%{name: translation_key1.name}).id
    end

    test "returns nil for unexisted params" do
      assert nil == TranslationKeys.get_translation_key_by(%{name: "something"})
    end
  end

  describe ".change_translation_key" do
    test "returns changeset", %{translation_key1: translation_key1} do
      assert %Ecto.Changeset{data: %TranslationKey{}} = TranslationKeys.change_translation_key(translation_key1)
    end
  end

  describe ".create_translation_key" do
    setup [:create_user]
    setup [:create_service]

    test "creates translation_key for valid params", %{user: user, service: service} do
      assert {:ok, %TranslationKey{}} = @translation_key_params |> Map.merge(%{user_id: user.id, service_id: service.id}) |> TranslationKeys.create_translation_key()
    end

    test "does not create translation_key for invalid params" do
      assert {:error, %Ecto.Changeset{}} = TranslationKeys.create_translation_key(@invalid_translation_key_params)
    end
  end

  describe ".update_translation_key" do
    test "updates translation_key for valid params", %{translation_key1: translation_key1} do
      assert {:ok, %TranslationKey{} = translation_key} = TranslationKeys.update_translation_key(translation_key1, %{name: "new key name"})
      assert translation_key.name == "new key name"
    end
  end

  describe ".delete_translation_key" do
    test "deletes translation_key for existed translation_key", %{translation_key1: translation_key1} do
      assert {:ok, %TranslationKey{}} = TranslationKeys.delete_translation_key(translation_key1)
    end
  end

  defp create_translation_keys(_) do
    translation_key1 = insert(:translation_key)
    translation_key2 = insert(:translation_key)
    {:ok, translation_key1: translation_key1, translation_key2: translation_key2}
  end

  defp create_user(_) do
    user = insert(:user)
    {:ok, user: user}
  end

  defp create_service(_) do
    service = insert(:service)
    {:ok, service: service}
  end
end