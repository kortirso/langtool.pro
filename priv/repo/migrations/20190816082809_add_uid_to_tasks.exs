defmodule LangtoolPro.Repo.Migrations.AddUidToTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :uid, :string
    end
  end
end
