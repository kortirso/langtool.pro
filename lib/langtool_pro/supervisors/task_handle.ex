defmodule LangtoolPro.Supervisors.TaskHandle do
  def call(task) do
    opts = [restart: :temporary]
    Task.Supervisor.start_child(__MODULE__, LangtoolProWeb.Services.TaskHandleService, :call, [task], opts)
  end
end
