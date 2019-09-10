defmodule LangtoolProWeb.Services.TaskHandleService do
  @moduledoc """
  Service for handling task for localization
  """

  alias LangtoolPro.{Tasks, Tasks.Task}
  alias LangtoolProWeb.Services.TaskTranslateService

  @doc """
  Localize file

  ## Examples

      iex> LangtoolProWeb.Services.TaskHandleService.call(task)

  """
  def call(%Task{} = task, framework) when is_binary(framework) do
    url = LangtoolPro.File.url({task.file, task}, signed: true)
    extension = url |> String.split("/") |> Enum.at(-1) |> String.split(".") |> Enum.at(-1)
    file = File.cwd! |> Path.join(url)
    case File.read(file) do
      {:ok, _} -> convert_file(task, file, extension, framework)
      _ -> task_update_status(task, "failed")
    end
  end

  defp convert_file(task, file, _, "react_js"), do: file |> I18nParser.convert("json", %{data_with_locale: true}) |> check_converted_data(task)
  defp convert_file(task, file, _, "laravel"), do: file |> I18nParser.convert("json", %{data_with_locale: false}) |> check_converted_data(task)
  defp convert_file(task, file, extension, _), do: file |> I18nParser.convert(extension) |> check_converted_data(task)

  defp check_converted_data(value, task) do
    case value do
      {:ok, converted_data, sentences} -> activate_task(task, converted_data, sentences)
      _ -> task_update_status(task, "failed")
    end
  end

  defp activate_task(task, converted_data, sentences) do
    {:ok, task} = task_update_status(task, "active")
    {:ok, result} = Yml.write_to_string(%{task.to => converted_data})
    translate_task(task, sentences, result)
  end

  defp translate_task(task, sentences, temp_data) do
    sentences
    |> TaskTranslateService.call(task)
    |> generate_result_file(task, temp_data)
    |> case do
      {:ok, task} -> task_update_status(task, "completed")
      _ -> task_update_status(task, "failed")
    end
  end

  defp generate_result_file(result, task, temp_data) do
    result
    |> Enum.reduce(temp_data, fn {index, _, translation}, acc ->
      String.replace(acc, "###{index}##", translation)
    end)
    |> Tasks.save_result_file(task)
  end

  defp task_update_status(task, status) do
    Tasks.update_task_status(task, status)
  end
end
