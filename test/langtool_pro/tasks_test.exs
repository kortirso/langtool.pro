defmodule LangtoolPro.TasksTest do
  use LangtoolProWeb.ConnCase
  import LangtoolPro.Factory
  alias LangtoolPro.{Tasks, Tasks.Task}

  setup [:create_tasks]

  @task_params %{
    from: "en",
    to: "ru",
    status: "created"
  }

  @invalid_task_params %{
    from: "",
    to: "",
    status: "created"
  }

  @task_file_params %{
    file: %Plug.Upload{path: "test/fixtures/ru.yml", filename: "ru.yml"}
  }

  @task_invalid_file_params %{
    file: %Plug.Upload{path: "test/fixtures/invalid.yml", filename: "invalid.yml"}
  }

  describe ".get_tasks_for_user" do
    test "returns tasks for existed id", %{task1: task1} do
      result = Tasks.get_tasks_for_user(task1.user_id)

      assert length(result) == 1
      assert Enum.at(result, 0).id == task1.id
    end

    test "returns [] for user without tasks", %{task1: task1, task2: task2} do
      assert [] == Tasks.get_tasks_for_user(task1.user_id + task2.user_id)
    end
  end

  describe ".get_task" do
    test "returns task for existed id", %{task1: task1} do
      assert task1.id == Tasks.get_task(task1.id).id
    end

    test "returns nil for unexisted id", %{task1: task1, task2: task2} do
      assert nil == Tasks.get_task(task1.id + task2.id)
    end
  end

  describe ".change_task" do
    test "returns changeset", %{task1: task1} do
      assert %Ecto.Changeset{data: %Task{}} = Tasks.change_task(task1)
    end
  end

  describe ".create_task" do
    setup [:create_user]

    test "creates task for valid params", %{user: user, translation_key1: translation_key} do
      assert {:ok, %Task{}} = @task_params |> Map.merge(%{user_id: user.id, translation_key_id: translation_key.id}) |> Tasks.create_task()
    end

    test "does not create for valid params but for restricted translation key", %{user: user, translation_key2: translation_key} do
      assert {:error, %Ecto.Changeset{} = changeset} = @task_params |> Map.merge(%{user_id: user.id, translation_key_id: translation_key.id}) |> Tasks.create_task()
      assert changeset.errors == [translation_key: {"does not belong to user", []}]
    end

    test "does not create for valid params but for unexisted translation key", %{user: user} do
      assert {:error, %Ecto.Changeset{} = changeset} = @task_params |> Map.merge(%{user_id: user.id, translation_key_id: 999999}) |> Tasks.create_task()
      assert changeset.errors == [translation_key: {"is not found", []}]
    end

    test "does not create task for invalid params", %{user: user, translation_key1: translation_key} do
      assert {:error, %Ecto.Changeset{}} = @invalid_task_params |> Map.merge(%{user_id: user.id, translation_key_id: translation_key.id}) |> Tasks.create_task()
    end
  end

  describe ".update_task_status" do
    test "updates task status for valid params", %{task1: task1} do
      assert {:ok, %Task{}} = Tasks.update_task_status(task1, "completed")
    end

    test "does not update task status for invalid params", %{task1: task1} do
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task_status(task1, "processing")
    end
  end

  describe ".update_task" do
    setup [:create_user]

    test "updates task for valid params", %{task1: task1, user: user} do
      assert {:ok, %Task{} = task} = Tasks.update_task(task1, %{user_id: user.id})
      assert task.user_id == user.id
    end
  end

  describe ".attach_file" do
    test "attaches file to task", %{task1: task1} do
      assert {:ok, task_with_file} = Tasks.attach_file(task1, @task_file_params)
      assert task_with_file.file != nil
    end
  end

  describe ".delete_task" do
    test "deletes task for existed task", %{task1: task1} do
      assert {:ok, %Task{}} = Tasks.delete_task(task1)
    end
  end

  describe ".detect_locale" do
    test "detects locale for valid file" do
      assert {:ok, %{code: "ru"}} = Tasks.detect_locale("ru.yml", @task_file_params.file.path, "ruby_on_rails")
    end

    test "does not detect locale for invalid file" do
      assert {:error, _} = Tasks.detect_locale("ru.yml", @task_invalid_file_params.file.path, "ruby_on_rails")
    end
  end

  defp create_tasks(_) do
    translation_key = insert(:translation_key)
    task1 = insert(:task, translation_key: translation_key)
    task2 = insert(:task, translation_key: translation_key)
    {:ok, task1: task1, task2: task2}
  end

  defp create_user(_) do
    user = insert(:user)
    translation_key1 = insert(:translation_key, user: user)
    translation_key2 = insert(:translation_key)
    {:ok, user: user, translation_key1: translation_key1, translation_key2: translation_key2}
  end
end
