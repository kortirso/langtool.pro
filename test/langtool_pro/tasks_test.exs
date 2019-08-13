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

  describe ".create_task" do
    setup [:create_user]

    test "creates task for valid params", %{user: user} do
      assert {:ok, %Task{}} = @task_params |> Map.merge(%{user_id: user.id}) |> Tasks.create_task()
    end

    test "does not create task for invalid params" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_task_params)
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

  defp create_tasks(_) do
    task1 = insert(:task)
    task2 = insert(:task)
    {:ok, task1: task1, task2: task2}
  end

  defp create_user(_) do
    user = insert(:user)
    {:ok, user: user}
  end
end