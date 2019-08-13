defmodule LangtoolProWeb.TasksController do
  use LangtoolProWeb, :controller
  alias LangtoolPro.{Tasks, Tasks.Task}

  plug :check_auth when action in [:index, :new, :create, :delete]
  plug :check_confirmation when action in [:index, :new, :create, :delete]
  plug :find_task when action in [:delete]
  plug :check_authorize when action in [:delete]

  def index(conn, _) do
    conn
    |> assign(:tasks, Tasks.get_tasks_for_user(conn.assigns.current_user.id))
    |> render("index.html")
  end

  def new(conn, _) do
    conn
    |> assign(:changeset, Tasks.change_task(%Task{}))
    |> render("new.html")
  end

  def create(conn, %{"task" => task_params}) do
    task_params
    |> Map.merge(%{"user_id" => conn.assigns.current_user.id})
    |> Tasks.create_task()
    |> case do
      {:ok, task} ->
        case Tasks.attach_file(task, task_params) do
          {:ok, _} ->
            conn
            |> put_flash(:success, "Task created successfully.")
            |> redirect(to: tasks_path(conn, :index))
          _ ->
            conn
            |> put_flash(:danger, "File attaching error")
            |> render("new.html")
        end
      {:error, _} ->
        conn
        |> put_flash(:danger, "Task is not created")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    Tasks.delete_task(conn.assigns.task)
    conn
    |> put_flash(:success, "Task deleted successfully.")
    |> redirect(to: tasks_path(conn, :index))
  end

  defp find_task(conn, _) do
    task = conn.params["id"] |> String.to_integer() |> Tasks.get_task()
    case task do
      nil ->
        conn
        |> put_flash(:danger, "Task is not found")
        |> redirect(to: tasks_path(conn, :index))
        |> halt()
      _ ->
        assign(conn, :task, task)
    end
  end

  defp check_authorize(conn, _) do
    authorize(conn, :task, :"#{conn.private.phoenix_action}?", conn.assigns.task)
  end
end
