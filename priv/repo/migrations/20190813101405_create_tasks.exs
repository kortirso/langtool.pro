defmodule LangtoolPro.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :user_id, references(:users), null: false
      add :file, :string
      add :result_file, :string
      add :from, :string
      add :to, :string
      add :status, :string, null: false, default: "created"
      timestamps()
    end
    create index(:tasks, [:user_id])
  end
end
