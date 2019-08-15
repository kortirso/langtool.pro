defmodule LangtoolPro.TranslationKeys.TranslationKey do
  use Ecto.Schema
  import Ecto.Changeset
  alias LangtoolPro.{TranslationKeys.TranslationKey, Users.User, Tasks.Task, Services.Service}

  schema "translation_keys" do
    field :name, :string
    field :value, :string

    belongs_to :user, User
    belongs_to :service, Service

    has_many :tasks, Task, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(%TranslationKey{} = translation_key, attrs) do
    translation_key
    |> cast(attrs, [:name, :service_id, :value, :user_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:service)
    |> validate_required([:name, :value])
  end
end
