defmodule LangtoolPro.UsersTest do
  use LangtoolProWeb.ConnCase
  import LangtoolPro.Factory
  alias LangtoolPro.{Users, Users.User}

  setup [:create_users]

  @user_params %{
    email: "something@gmail.com",
    encrypted_password: "1234567890"
  }

  @invalid_user_params %{
    email: "something@gmail.com",
    encrypted_password: ""
  }

  test "get_users, returns all users", %{user1: user1, user2: user2} do
    result = Users.get_users()

    assert is_list(result) == true
    assert length(result) == 2
    assert Enum.at(result, 0) == user1
    assert Enum.at(result, 1) == user2
  end

  describe ".get_user" do
    test "returns user for existed id", %{user1: user1} do
      assert user1 == Users.get_user(user1.id)
    end

    test "returns nil for unexisted id", %{user1: user1, user2: user2} do
      assert nil == Users.get_user(user1.id + user2.id)
    end
  end

  describe ".get_user_by" do
    test "returns user for existed params", %{user1: user1} do
      assert user1 == Users.get_user_by(%{email: user1.email})
    end

    test "returns nil for unexisted params" do
      assert nil == Users.get_user_by(%{email: "something@gmail.com"})
    end
  end

  describe ".create_user" do
    test "creates user for valid params" do
      assert {:ok, %User{}} = Users.create_user(@user_params)
    end

    test "does not create user for invalid params" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_user_params)
    end
  end

  defp create_users(_) do
    user1 = insert(:user)
    user2 = insert(:user)
    {:ok, user1: user1, user2: user2}
  end
end