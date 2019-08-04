defmodule LangtoolPro.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias LangtoolPro.{Repo, Users.User}

  @doc """
  Returns the list of users

  ## Examples

      iex> get_users()
      [%User{}, ...]

  """
  def get_users do
    User
    |> order_by(asc: :id)
    |> Repo.all()
  end

  @doc """
  Gets a single user

  ## Examples

      iex> get_user(123)
      %User{}

      iex> get_user(456)
      nil

  """
  def get_user(id) when is_integer(id), do: Repo.get(User, id)

  @doc """
  Gets a single user by params

  ## Examples

      iex> get_user_by(%{email: email})
      %User{}

      iex> get_user_by(%{email: email})
      nil

  """
  def get_user_by(user_params) when is_map(user_params), do: Repo.get_by(User, user_params)

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user), do: User.changeset(user, %{})

  @doc """
  Creates a user

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(user_params) when is_map(user_params) do
    %User{}
    |> User.create_changeset(user_params)
    |> Repo.insert()
  end
end
