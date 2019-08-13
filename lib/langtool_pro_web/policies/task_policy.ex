defmodule LangtoolProWeb.TaskPolicy do
  alias LangtoolPro.{Users.User, Tasks.Task}

  def delete?(%User{id: id}, %Task{user_id: user_id}), do: user_id == id
end