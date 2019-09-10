defmodule LangtoolProWeb.Api.V1.TasksController do
  use LangtoolProWeb, :controller_api
  alias LangtoolPro.{Tasks}

  def detection(conn, %{"file" => %Plug.Upload{filename: filename, path: path}, "framework" => framework}) do
    case Tasks.detect_locale(filename, path, framework) do
      {:ok, message} ->
        conn
        |> put_status(200)
        |> render("detection.json", message: message)
      {:error, message} ->
        conn
        |> put_status(200)
        |> render("detection.json", message: message)
      _ ->
        render_error(conn, 400, "Unknown error")
    end
  end
end
