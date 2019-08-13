defmodule LangtoolPro.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias LangtoolPro.{Repo, Tasks.Task}

  @doc """
  Get tasks list for user

  ## Examples

      iex> get_tasks_for_user(user)

  """
  def get_tasks_for_user(user_id) when is_integer(user_id) do
    query =
      from task in Task,
      where: task.user_id == ^user_id,
      order_by: [desc: task.id]

    Repo.all(query)
  end

  @doc """
  Gets a single task

  ## Examples

      iex> get_task(123)
      %Task{}

      iex> get_task(123)
      nil

  """
  def get_task(id) when is_integer(id), do: Repo.get(Task, id)

  @doc """
  Creates a task

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs) when is_map(attrs) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates status of the task

  ## Examples

      iex> update_task_status(task, status)
      {:ok, %Task{}}

  """
  def update_task_status(%Task{} = task, status) when is_binary(status) do
    task
    |> Task.status_changeset(%{status: status})
    |> Repo.update()
  end

  @doc """
  Attaches file to task

  ## Examples

      iex> attach_file(task, %{field: value})

  """
  def attach_file(%Task{} = task, attrs) when is_map(attrs) do
    task
    |> Task.file_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

  """
  def delete_task(%Task{} = task), do: Repo.delete(task)
end
