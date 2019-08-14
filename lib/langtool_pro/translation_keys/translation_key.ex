defmodule LangtoolPro.TranslationKeys.TranslationKey do
  use Ecto.Schema
  import Ecto.Changeset
  alias LangtoolPro.{TranslationKeys.TranslationKey, Users.User, Tasks.Task}

  schema "translation_keys" do
    field :name, :string
    field :service, :string
    field :value, :string

    belongs_to :user, User

    has_many :tasks, Task

    timestamps()
  end

  @doc false
  def changeset(%TranslationKey{} = translation_key, attrs) do
    translation_key
    |> cast(attrs, [:name, :service, :value, :user_id])
    |> assoc_constraint(:user)
    |> validate_required([:name, :service, :value])
    |> validate_inclusion(:service, ["google", "yandex"])
  end
end
