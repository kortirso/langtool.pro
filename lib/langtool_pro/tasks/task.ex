defmodule LangtoolPro.Tasks.Task do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset
  alias LangtoolPro.{Users.User, Tasks.Task, TranslationKeys, TranslationKeys.TranslationKey, Helpers}

  schema "tasks" do
    field :file, LangtoolPro.File.Type
    field :result_file, LangtoolPro.ResultFile.Type
    field :from, :string
    field :to, :string
    field :status, :string
    field :uid, :string

    belongs_to :user, User
    belongs_to :translation_key, TranslationKey

    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:user_id, :translation_key_id, :from, :to, :status])
    |> assoc_constraint(:user)
    |> validate_translation_key()
    |> validate_required([:from, :to, :status])
    |> validate_inclusion(:status, ["created", "active", "failed", "completed"])
    |> validate_length(:from, min: 2)
    |> validate_length(:to, min: 2)
    |> put_change(:uid, Helpers.random_string(12))
  end

  @doc false
  def file_changeset(%Task{} = task, attrs) do
    task
    |> cast_attachments(attrs, [:file], [])
    |> validate_required([:file])
  end

  @doc false
  def result_file_changeset(%Task{} = task, attrs) do
    task
    |> cast_attachments(attrs, [:result_file], [])
    |> validate_required([:result_file])
  end

  @doc false
  def status_changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:status])
    |> validate_inclusion(:status, ["created", "active", "failed", "completed"])
  end

  defp validate_translation_key(changeset) do
    validate_change(changeset, :translation_key_id, fn _, translation_key_id ->
      case TranslationKeys.get_translation_key(translation_key_id) do
        nil ->
          [translation_key: "is not found"]
        translation_key ->
          case translation_key.user_id == get_field(changeset, :user_id) do
            true -> []
            _ -> [translation_key: "does not belong to user"]
          end
      end
    end)
  end
end
