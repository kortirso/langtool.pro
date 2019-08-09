defmodule LangtoolPro.Repo.Migrations.CreateTranslationKeys do
  use Ecto.Migration

  def change do
    create table(:translation_keys) do
      add :user_id, references(:users), null: false
      add :name, :string, null: false, default: ""
      add :service, :string, null: false, default: ""
      add :value, :string, null: false, default: ""
      timestamps()
    end
    create index(:translation_keys, [:user_id])
  end
end
