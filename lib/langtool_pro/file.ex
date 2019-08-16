defmodule LangtoolPro.File do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original]

  def storage_dir(_version, {_, task}) do
    if Mix.env == :test do
      "uploads/test/#{task.id}/#{task.uid}/original"
    else
      "uploads/#{task.id}/#{task.uid}/original"
    end
  end

  def temp_storage_dir(_version, {_, task}) do
    if Mix.env == :test do
      "uploads/test/#{task.id}/#{task.uid}/temp"
    else
      "uploads/#{task.id}/#{task.uid}/temp"
    end
  end
end
