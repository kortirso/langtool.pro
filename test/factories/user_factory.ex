defmodule LangtoolPro.UserFactory do
  alias LangtoolPro.{Users, Users.User}
  alias Comeonin.Bcrypt

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %User{
          email: sequence(:email, &"email-#{&1}@example.com"),
          encrypted_password: Bcrypt.hashpwsalt("1234567890")
        }
      end

      def confirm(%User{} = user) do
        {:ok, updated_user} = user |> Users.update_user(%{confirmed_at: DateTime.utc_now})
        updated_user
      end
    end
  end
end
