defmodule LangtoolPro.ResultFile do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original]

  def storage_dir(_version, {_, task}) do
    if Mix.env == :test do
      "uploads/test/#{task.id}/result"
    else
      "uploads/#{task.id}/result"
    end
  end
end
