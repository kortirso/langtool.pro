defmodule LangtoolPro.Services do
  @moduledoc """
  The Services context.
  """

  import Ecto.Query, warn: false
  alias LangtoolPro.{Repo, Services.Service}

  @doc """
  Returns the list of services

  ## Examples

      iex> list_services()
      [%Service{}, ...]

  """
  def list_services, do: Repo.all(Service)

  @doc """
  Gets a single service

  ## Examples

      iex> get_service(123)
      %Service{}

      iex> get_service(456)
      nil

  """
  def get_service(id) when is_integer(id), do: Repo.get(Service, id)

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking service changes

  ## Examples

      iex> change_service(service)
      %Ecto.Changeset{source: %Service{}}

  """
  def change_service(%Service{} = service), do: Service.changeset(service, %{})

  @doc """
  Creates a service

  ## Examples

      iex> create_service(%{field: value})
      {:ok, %Service{}}

      iex> create_service(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_service(attrs) when is_map(attrs) do
    %Service{}
    |> Service.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a Service

  ## Examples

      iex> delete_service(service)
      {:ok, %Service{}}

      iex> delete_service(service)
      {:error, %Ecto.Changeset{}}

  """
  def delete_service(%Service{} = service), do: Repo.delete(service)
end
