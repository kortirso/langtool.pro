defmodule LangtoolPro.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt
  alias LangtoolPro.{TranslationKeys.TranslationKey, Tasks.Task, Helpers}

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :confirmation_token, :string
    field :confirmed_at, :naive_datetime

    has_many :translation_keys, TranslationKey, on_delete: :delete_all
    has_many :tasks, Task, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :encrypted_password, :confirmed_at, :confirmation_token])
    |> validate_required([:email, :encrypted_password])
    |> validate_length(:encrypted_password, min: 10)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
    |> update_change(:encrypted_password, &Bcrypt.hashpwsalt/1)
    |> put_change(:confirmed_at, nil)
    |> put_change(:confirmation_token, Helpers.random_string(24))
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:confirmed_at])
  end
end
