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
  def get_user_by(attrs) when is_map(attrs), do: Repo.get_by(User, attrs)

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
  def create_user(attrs) when is_map(attrs) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) when is_map(attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

  """
  def delete_user(%User{} = user), do: Repo.delete(user)

  @doc """
  Confirms user's email

  ## Examples

      iex> confirm_user(email, confirmation_token)

  """
  def confirm_user(email, confirmation_token) when is_binary(email) do
    case get_user_by(%{email: email}) do
      nil -> {:error, "User is not found for confirmation"}
      user -> do_confirm_user(user, confirmation_token)
    end
  end

  defp do_confirm_user(user, confirmation_token) do
    cond do
      user.confirmation_token != confirmation_token -> {:error, "Confirmation token is invalid"}
      user.confirmed_at != nil -> {:error, "Email is already confirmed"}
      true -> update_user_confirmation(user)
    end
  end

  defp update_user_confirmation(user) do
    case update_user(user, %{confirmed_at: DateTime.utc_now}) do
      {:ok, user} -> {:ok, user}
      {:error, _} -> {:error, "Email confirmation error"}
    end
  end
end
