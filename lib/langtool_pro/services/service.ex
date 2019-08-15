defmodule LangtoolPro.Services.Service do
  use Ecto.Schema
  import Ecto.Changeset
  alias LangtoolPro.{TranslationKeys.TranslationKey, Services.Service}

  schema "services" do
    field :name, :string

    has_many :translation_keys, TranslationKey, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(%Service{} = service, %{} = attrs) do
    service
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_inclusion(:name, ["systran"])
  end
end
