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
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_translation_key(task)
      %Ecto.Changeset{source: %Task{}}

  """
  def change_task(%Task{} = task), do: Task.changeset(task, %{})

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
  Updates a task

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) when is_map(attrs) do
    task
    |> Task.changeset(attrs)
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

  @doc """
  Detects locale for file

  ## Examples

      iex> detect_locale(filename, path)
      {:ok, %{code: "en"}}

      iex> detect_locale(filename, path)
      {:error, ""}

  """
  def detect_locale(filename, path) when is_binary(filename) and is_binary(path) do
    extension =
      filename
      |> String.split(".")
      |> Enum.at(-1)
    I18nParser.detect(path, extension)
  end

  @doc """
  Attaches result file to task

  ## Examples

      iex> save_result_file("content", task)

  """
  def save_result_file(result_file_content, %Task{} = task) when is_binary(result_file_content) do
    result_file_name = task.to <> ".yml"
    # create temp folder
    temp_folder = File.cwd! |> Path.join(LangtoolPro.File.temp_storage_dir(:original, {:abc, task}))
    File.mkdir(temp_folder)
    # create temp file
    temp_file_path = temp_folder <> "/#{result_file_name}"
    File.write(temp_file_path, result_file_content)
    # attach temp file as result to task
    save_result = attach_result_file(task, %{result_file: %Plug.Upload{filename: result_file_name, path: temp_file_path}})
    # delete temp file
    File.rm(temp_file_path)
    save_result
  end

  defp attach_result_file(%Task{} = task, %{} = attrs) do
    task
    |> Task.result_file_changeset(attrs)
    |> Repo.update()
  end
end
