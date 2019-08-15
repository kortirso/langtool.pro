defmodule LangtoolProWeb.Services.TaskTranslateService do
  @moduledoc """
  Service for translating texts
  """

  alias LangtoolPro.{Tasks, Tasks.Task, TranslationKeys}

  @doc """
  Translate

  ## Examples

      iex> LangtoolProWeb.Services.TaskTranslateService.call(sentences, task)

  """
  def call(sentences, %Task{} = task) do
    task.id
    |> define_translate_service()
    |> case do
      nil -> Enum.map(sentences, fn {index, original} -> {index, original, "#{original}000"} end)
      service ->
        case service.name do
          "systran" -> translate(:systran, sentences, task)
          _ -> Enum.map(sentences, fn {index, original} -> {index, original, "#{original}---"} end)
        end
    end
  end

  defp define_translate_service(task_id), do: Tasks.get_service_for_task(task_id)

  # translation with SYSTRAN service
  defp translate(:systran, sentences, task) do
    key = TranslationKeys.get_translation_key(task.translation_key_id).value
    Enum.map(sentences, fn {index, original} ->
      {index, original, do_systran_translate(key, original, task.from, task.to, 0)}
    end)
  end

  defp do_systran_translate(_, input, _, _, 3), do: "#{input}---"

  defp do_systran_translate(key, input, source, target, index) do
    case Systran.Translate.translate(%{key: key, input: input, source: source, target: target}) do
      {:error, :timeout} ->
        Process.sleep(500)
        do_systran_translate(key, input, source, target, index + 1)
      {:error, _} ->
        "#{input}---"
      {:ok, result} ->
        result["outputs"]
        |> Enum.at(0)
        |> Map.get("output")
    end
  end
end
