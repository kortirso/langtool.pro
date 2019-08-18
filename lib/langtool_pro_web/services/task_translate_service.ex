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
    Galnora.Server.add_job(sentences, %{uid: task.id, type: :systran, from: task.from, to: task.to, keys: %{key: key}})

    wait_job_completeness(task.id)
    sentences = Galnora.Server.get_job_with_sentences(task.id)
    Galnora.Server.delete_job(task.id)

    sentences
  end

  defp wait_job_completeness(job_uid) do
    job = Galnora.Server.get_job(job_uid)
    case job.status do
      :active ->
        Process.sleep(2000)
        wait_job_completeness(job_uid)
      _ ->
        :ok
    end
  end
end
