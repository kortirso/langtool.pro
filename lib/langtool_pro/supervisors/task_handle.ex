defmodule LangtoolPro.Supervisors.TaskHandle do
  def call(task, framework) do
    opts = [restart: :temporary]
    Task.Supervisor.start_child(__MODULE__, LangtoolProWeb.Services.TaskHandleService, :call, [task, framework], opts)
  end
end
