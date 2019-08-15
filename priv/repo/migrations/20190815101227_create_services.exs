defmodule LangtoolPro.Repo.Migrations.CreateServices do
  use Ecto.Migration

  def change do
    create table(:services) do
      add :name, :string
      timestamps()
    end

    alter table(:translation_keys) do
      remove :service
      add :service_id, references(:services), null: false
    end
    create index(:translation_keys, [:service_id])
  end
end
