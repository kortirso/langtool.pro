defmodule LangtoolPro.TranslationKeys do
  @moduledoc """
  The TranslationKeys context.
  """

  import Ecto.Query, warn: false
  alias LangtoolPro.{Repo, TranslationKeys.TranslationKey}

  @doc """
  Returns the list of translation_keys for user.

  ## Examples

      iex> get_translation_keys_for_user(user_id)
      [%TranslationKey{}, ...]

  """
  def get_translation_keys_for_user(user_id) when is_integer(user_id) do
    query =
      from translation_key in TranslationKey,
      where: translation_key.user_id == ^user_id,
      order_by: [asc: translation_key.id],
      preload: [:service]

    Repo.all(query)
  end

  @doc """
  Gets a single translation_key

  ## Examples

      iex> get_translation_key(123)
      %TranslationKey{}

      iex> get_translation_key(456)
      nil

  """
  def get_translation_key(id) when is_integer(id), do: Repo.get(TranslationKey, id)

  @doc """
  Gets a single translation_key by params

  ## Examples

      iex> get_translation_key_by(%{user_id: user_id})
      %TranslationKey{}

      iex> get_translation_key_by(%{user_id: user_id})
      nil

  """
  def get_translation_key_by(attrs) when is_map(attrs), do: Repo.get_by(TranslationKey, attrs)

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking translation_key changes.

  ## Examples

      iex> change_translation_key(translation_key)
      %Ecto.Changeset{source: %TranslationKey{}}

  """
  def change_translation_key(%TranslationKey{} = translation_key), do: TranslationKey.changeset(translation_key, %{})

  @doc """
  Creates a translation_key

  ## Examples

      iex> create_translation_key(%{field: value})
      {:ok, %TranslationKey{}}

      iex> create_translation_key(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_translation_key(attrs) when is_map(attrs) do
    %TranslationKey{}
    |> TranslationKey.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a translation_key

  ## Examples

      iex> update_translation_key(translation_key, %{field: new_value})
      {:ok, %TranslationKey{}}

      iex> update_translation_key(translation_key, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_translation_key(%TranslationKey{} = translation_key, attrs) when is_map(attrs) do
    translation_key
    |> TranslationKey.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a TranslationKey

  ## Examples

      iex> delete_translation_key(translation_key)
      {:ok, %TranslationKey{}}

  """
  def delete_translation_key(%TranslationKey{} = translation_key), do: Repo.delete(translation_key)
end
