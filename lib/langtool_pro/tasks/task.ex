defmodule LangtoolPro.Tasks.Task do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset
  alias LangtoolPro.{Users.User, Tasks.Task}

  schema "tasks" do
    field :file, LangtoolPro.File.Type
    field :result_file, LangtoolPro.ResultFile.Type
    field :from, :string
    field :to, :string
    field :status, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:user_id, :from, :to, :status])
    |> assoc_constraint(:user)
    |> validate_required([:from, :to, :status])
    |> validate_inclusion(:status, ["created", "active", "failed", "completed"])
    |> validate_length(:from, min: 2)
    |> validate_length(:to, min: 2)
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
end
