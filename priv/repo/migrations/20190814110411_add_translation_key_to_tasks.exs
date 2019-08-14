defmodule LangtoolPro.Repo.Migrations.AddTranslationKeyToTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :translation_key_id, references(:translation_keys), null: false
    end

    create index(:tasks, [:translation_key_id])
  end
end
