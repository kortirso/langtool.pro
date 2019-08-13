defmodule LangtoolPro.TaskFactory do
  alias LangtoolPro.Tasks.Task

  defmacro __using__(_opts) do
    quote do
      def task_factory do
        %Task{
          from: "ru",
          to: "en",
          status: "created",
          user: build(:user)
        }
      end
    end
  end
end
