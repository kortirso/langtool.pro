defmodule LangtoolProWeb.TasksControllerTest do
  use LangtoolProWeb.ConnCase
  import LangtoolPro.Factory
  alias LangtoolPro.Tasks

  setup [:create_user]

  @task_params %{
    file: %Plug.Upload{path: "test/fixtures/ru.yml", filename: "ru.yml"},
    from: "en",
    to: "ru",
    _csrf_token: "1234567890",
    status: "created"
  }

  @invalid_task_params %{
    file: %Plug.Upload{path: "test/fixtures/ru.yml", filename: "ru.yml"},
    from: "",
    to: "",
    _csrf_token: "1234567890",
    status: "created"
  }

  describe "GET#index" do
    test "redirects to welcome page for guest", %{conn: conn} do
      conn = get conn, tasks_path(conn, :index)

      assert redirected_to(conn) == welcome_path(conn, :index)
      assert get_flash(conn, :danger) == "You need to be signed in to access that page."
    end

    test "redirects to welcome page for unconfirmed user", %{user: user} do
      conn = session_conn() |> put_session(:current_user_id, user.id)
      conn = conn |> get(tasks_path(conn, :index))

      assert redirected_to(conn) == welcome_path(conn, :index)
      assert get_flash(conn, :danger) == "You need to confirm your email."
    end

    test "redirects to tasks page for confirmed user", %{confirmed_user: confirmed_user} do
      conn = session_conn() |> put_session(:current_user_id, confirmed_user.id)
      conn = conn |> get(tasks_path(conn, :index))

      assert html_response(conn, 200) =~ "Tasks"
    end
  end

  describe "GET#new" do
    test "redirects to welcome page for guest", %{conn: conn} do
      conn = get conn, tasks_path(conn, :new)

      assert redirected_to(conn) == welcome_path(conn, :index)
      assert get_flash(conn, :danger) == "You need to be signed in to access that page."
    end

    test "redirects to welcome page for unconfirmed user", %{user: user} do
      conn = session_conn() |> put_session(:current_user_id, user.id)
      conn = conn |> get(tasks_path(conn, :new))

      assert redirected_to(conn) == welcome_path(conn, :index)
      assert get_flash(conn, :danger) == "You need to confirm your email."
    end

    test "redirects to new task page for confirmed user", %{confirmed_user: confirmed_user} do
      conn = session_conn() |> put_session(:current_user_id, confirmed_user.id)
      conn = conn |> get(tasks_path(conn, :new))

      assert html_response(conn, 200) =~ "New task"
    end
  end

  describe "POST#create" do
    test "redirects to welcome page for guest", %{conn: conn} do
      conn = post conn, tasks_path(conn, :create), task: %{}, framework: "ruby_on_rails"

      assert redirected_to(conn) == welcome_path(conn, :index)
      assert get_flash(conn, :danger) == "You need to be signed in to access that page."
    end

    test "redirects to welcome page for unconfirmed user", %{user: user} do
      conn = session_conn() |> put_session(:current_user_id, user.id)
      conn = conn |> post(tasks_path(conn, :create), task: %{}, framework: "ruby_on_rails")

      assert redirected_to(conn) == welcome_path(conn, :index)
      assert get_flash(conn, :danger) == "You need to confirm your email."
    end

    test "does not create task for confirmed user and invalid attrs", %{confirmed_user: confirmed_user} do
      tasks_amount_before = length(Tasks.get_tasks_for_user(confirmed_user.id))

      conn = session_conn() |> put_session(:current_user_id, confirmed_user.id)
      conn = conn |> post(tasks_path(conn, :create), task: @invalid_task_params, framework: "ruby_on_rails")

      assert html_response(conn, 200) =~ "New task"
      assert get_flash(conn, :danger) != nil
      assert length(Tasks.get_tasks_for_user(confirmed_user.id)) == tasks_amount_before
    end

    test "create translation key for confirmed user and valid attrs", %{confirmed_user: confirmed_user, translation_key: translation_key} do
      tasks_amount_before = length(Tasks.get_tasks_for_user(confirmed_user.id))

      conn = session_conn() |> put_session(:current_user_id, confirmed_user.id)
      conn = conn |> post(tasks_path(conn, :create), task: @task_params |> Map.merge(%{translation_key_id: translation_key.id}), framework: "ruby_on_rails")

      assert redirected_to(conn) == tasks_path(conn, :index)
      assert get_flash(conn, :success) == "Task created successfully."
      assert length(Tasks.get_tasks_for_user(confirmed_user.id)) == tasks_amount_before + 1
    end
  end

  describe "DELETE#delete" do
    setup [:create_task]

    test "redirects to welcome page for guest", %{conn: conn} do
      conn = delete conn, tasks_path(conn, :delete, "999999")

      assert redirected_to(conn) == welcome_path(conn, :index)
      assert get_flash(conn, :danger) == "You need to be signed in to access that page."
    end

    test "redirects to welcome page for unconfirmed user", %{user: user} do
      conn = session_conn() |> put_session(:current_user_id, user.id)
      conn = conn |> delete(tasks_path(conn, :delete, "999999"))

      assert redirected_to(conn) == welcome_path(conn, :index)
      assert get_flash(conn, :danger) == "You need to confirm your email."
    end

    test "does not delete task for confirmed user and unexisted task", %{confirmed_user: confirmed_user} do
      conn = session_conn() |> put_session(:current_user_id, confirmed_user.id)
      conn = conn |> delete(tasks_path(conn, :delete, "999999"))

      assert redirected_to(conn) == tasks_path(conn, :index)
      assert get_flash(conn, :danger) == "Task is not found"
    end

    test "redirects to welcome page with Forbidden for confirmed user and existed task but for other user", %{confirmed_user: confirmed_user, task: task} do
      conn = session_conn() |> put_session(:current_user_id, confirmed_user.id)
      conn = conn |> delete(tasks_path(conn, :delete, task.id))

      assert redirected_to(conn) == welcome_path(conn, :index)
      assert get_flash(conn, :danger) == "Forbidden."
    end

    test "deletes task for confirmed user and existed task", %{confirmed_user: confirmed_user, task: task} do
      task |> Tasks.update_task(%{user_id: confirmed_user.id})
      tasks_amount_before = length(Tasks.get_tasks_for_user(confirmed_user.id))

      conn = session_conn() |> put_session(:current_user_id, confirmed_user.id)
      conn = conn |> delete(tasks_path(conn, :delete, task.id))

      assert redirected_to(conn) == tasks_path(conn, :index)
      assert get_flash(conn, :success) == "Task deleted successfully."
      assert length(Tasks.get_tasks_for_user(confirmed_user.id)) == tasks_amount_before - 1
    end
  end

  defp create_user(_) do
    user = insert(:user)
    confirmed_user = insert(:user) |> confirm()
    translation_key = insert(:translation_key, user: confirmed_user)
    {:ok, user: user, confirmed_user: confirmed_user, translation_key: translation_key}
  end

  defp create_task(_) do
    translation_key = insert(:translation_key)
    task = insert(:task, translation_key: translation_key)
    {:ok, task: task}
  end
end
