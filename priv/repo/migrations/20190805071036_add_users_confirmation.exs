defmodule LangtoolPro.Repo.Migrations.AddUsersConfirmation do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :confirmed_at, :naive_datetime
      add :confirmation_token, :string
    end
    create unique_index(:users, [:confirmation_token])
  end
end
