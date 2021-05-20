defmodule Mockatron.Plug.InvokeMock do
  import Plug.Conn
  alias Mockatron.Mock

  def init(options), do: options

  def call(%{assigns: %{request: request}} = conn, _opts) do
    case Mock.request(request) do
      {:ok, %HTTPoison.Response{body: body, status_code: status_code, headers: headers}} ->
        conn
        |> merge_resp_headers(headers)
        |> send_resp(status_code, body)

      _ ->
        conn
        |> halt()
    end
  end
end
