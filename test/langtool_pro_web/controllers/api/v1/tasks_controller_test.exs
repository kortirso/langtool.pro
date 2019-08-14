defmodule LangtoolProWeb.Api.V1.TasksControllerTest do
  use LangtoolProWeb.ConnCase

  describe "POST#detection" do
    test "returns code and name of locale", %{conn: conn} do
      path = File.cwd! |> Path.join("test/fixtures/ru.yml")
      conn = post conn, api_detection_path(conn, :detection), [file: %Plug.Upload{path: path, filename: "ru.yml"}]

      assert json_response(conn, 200) == %{"code" => "ru"}
    end

    test "returns error message for invalid file", %{conn: conn} do
      path = File.cwd! |> Path.join("test/fixtures/invalid.yml")
      conn = post conn, api_detection_path(conn, :detection), [file: %Plug.Upload{path: path, filename: "invalid.yml"}]

      assert json_response(conn, 200) == "Invalid amount of keys"
    end
  end
end
